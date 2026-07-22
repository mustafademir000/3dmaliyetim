import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/printer_model.dart';
import '../providers/app_settings_provider.dart';
import '../providers/printer_provider.dart';

class PrinterDialog extends StatefulWidget {
  final PrinterModel? printerToEdit;

  const PrinterDialog({super.key, this.printerToEdit});

  @override
  State<PrinterDialog> createState() => _PrinterDialogState();
}

class _PrinterDialogState extends State<PrinterDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _wattsController;
  late TextEditingController _wearController;

  @override
  void initState() {
    super.initState();
    final p = widget.printerToEdit;
    _nameController = TextEditingController(text: p?.name ?? 'Bambu Lab P1S');
    _wattsController = TextEditingController(text: p?.powerConsumptionWatts.toStringAsFixed(0) ?? '160');
    _wearController = TextEditingController(text: p?.hourlyWearCost.toStringAsFixed(1) ?? '10.0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wattsController.dispose();
    _wearController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final watts = double.parse(_wattsController.text);
      final wear = double.parse(_wearController.text);

      final printerProvider = context.read<PrinterProvider>();

      if (widget.printerToEdit != null) {
        final updated = PrinterModel(
          id: widget.printerToEdit!.id,
          name: name,
          powerConsumptionWatts: watts,
          hourlyWearCost: wear,
        );
        printerProvider.updatePrinter(updated);
      } else {
        final newPrinter = PrinterModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          powerConsumptionWatts: watts,
          hourlyWearCost: wear,
        );
        printerProvider.addPrinter(newPrinter);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context.watch<AppSettingsProvider>().currencySymbol;
    final isEditing = widget.printerToEdit != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(isEditing ? 'Yazıcıyı Düzenle' : 'Yeni Yazıcı Ekle'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Yazıcı Adı / Modeli',
                  hintText: 'Örn: Creality Ender 3 V2',
                ),
                validator: (v) => v == null || v.isEmpty ? 'İsim giriniz' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _wattsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Güç Tüketimi (Watt)',
                  suffixText: 'W',
                  hintText: 'Örn: 150',
                ),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Geçerli Watt giriniz' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _wearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Saatlik Aşınma / Amortisman',
                  suffixText: '$currencySymbol/saat',
                  hintText: 'Örn: 8.0',
                ),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Geçerli değer giriniz' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
