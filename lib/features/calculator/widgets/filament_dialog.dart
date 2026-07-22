import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filament_model.dart';
import '../providers/app_settings_provider.dart';
import '../providers/filament_provider.dart';

class FilamentDialog extends StatefulWidget {
  final FilamentModel? filamentToEdit;

  const FilamentDialog({super.key, this.filamentToEdit});

  @override
  State<FilamentDialog> createState() => _FilamentDialogState();
}

class _FilamentDialogState extends State<FilamentDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _brandController;
  late TextEditingController _nameController;
  late TextEditingController _pricePerKgController;

  String _materialType = 'PLA';

  final List<String> _materialOptions = [
    'PLA',
    'PLA+',
    'PETG',
    'ABS',
    'ASA',
    'TPU',
    'PVA',
    'PC',
    'Nylon (PA)',
    'Reçine (SLA)',
    'Diğer',
  ];

  @override
  void initState() {
    super.initState();
    final f = widget.filamentToEdit;
    _brandController = TextEditingController(text: f?.brand ?? 'eSUN');
    _nameController = TextEditingController(text: f?.name ?? 'PLA+ Siyah');
    _pricePerKgController = TextEditingController(text: f?.pricePerKg.toStringAsFixed(0) ?? '650');
    _materialType = f?.materialType ?? 'PLA';
  }

  @override
  void dispose() {
    _brandController.dispose();
    _nameController.dispose();
    _pricePerKgController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final brand = _brandController.text.trim();
      final name = _nameController.text.trim();
      final pricePerKg = double.parse(_pricePerKgController.text);

      final filamentProvider = context.read<FilamentProvider>();

      if (widget.filamentToEdit != null) {
        final updated = FilamentModel(
          id: widget.filamentToEdit!.id,
          brand: brand,
          name: name,
          materialType: _materialType,
          pricePerKg: pricePerKg,
        );
        filamentProvider.updateFilament(updated);
      } else {
        final newFilament = FilamentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          brand: brand,
          name: name,
          materialType: _materialType,
          pricePerKg: pricePerKg,
        );
        filamentProvider.addFilament(newFilament);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context.watch<AppSettingsProvider>().currencySymbol;
    final sym = (currencySymbol == '₺' || currencySymbol == 'TL') ? 'TL' : currencySymbol;
    final isEditing = widget.filamentToEdit != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(isEditing ? 'Filamenti Düzenle' : 'Yeni Filament Ekle'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _materialOptions.contains(_materialType) ? _materialType : 'Diğer',
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Malzeme Tipi'),
                items: _materialOptions.map((opt) {
                  return DropdownMenuItem(
                    value: opt,
                    child: Text(opt, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _materialType = val);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Marka',
                  hintText: 'Örn: eSUN, Porima, Bambu Lab',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Marka giriniz' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Filament / Model Adı',
                  hintText: 'Örn: PLA+ Siyah',
                ),
                validator: (v) => v == null || v.isEmpty ? 'İsim giriniz' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pricePerKgController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Filament 1 Kg Fiyatı (TL)',
                  suffixText: '$sym/kg',
                  hintText: 'Örn: 650',
                ),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Geçerli fiyat giriniz' : null,
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
