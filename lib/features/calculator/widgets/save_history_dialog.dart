import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/currency_formatter.dart';
import '../models/calculation_result.dart';
import '../models/history_item.dart';
import '../providers/app_settings_provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/filament_provider.dart';
import '../providers/history_provider.dart';
import '../providers/printer_provider.dart';

class SaveHistoryDialog extends StatefulWidget {
  final CalculationResult result;

  const SaveHistoryDialog({super.key, required this.result});

  @override
  State<SaveHistoryDialog> createState() => _SaveHistoryDialogState();
}

class _SaveHistoryDialogState extends State<SaveHistoryDialog> {
  late TextEditingController _titleController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final productTitle = context.read<CalculatorProvider>().productTitle;
    _titleController = TextEditingController(text: productTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final calc = context.read<CalculatorProvider>();
      final fil = context.read<FilamentProvider>();
      final prn = context.read<PrinterProvider>();
      final currencySymbol = context.read<AppSettingsProvider>().currencySymbol;

      final filamentName = calc.useCustomFilament
          ? 'Özel Filament'
          : (fil.selectedFilament?.name ?? 'PLA');
      final printerName = calc.useCustomPrinter
          ? 'Özel Yazıcı'
          : (prn.selectedPrinter?.name ?? 'Yazıcı');

      final item = HistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        date: DateTime.now(),
        usedFilamentGrams: calc.usedFilamentGrams,
        printTimeHours: calc.totalPrintTimeHours,
        filamentName: filamentName,
        printerName: printerName,
        currencySymbol: currencySymbol,
        result: widget.result,
      );

      context.read<HistoryProvider>().addItem(item);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context.watch<AppSettingsProvider>().currencySymbol;
    final sym = currencySymbol == '₺' ? 'TL' : currencySymbol;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Hesaplamayı Kaydet'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ürün / Model İsmi:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Örn: Masa Üstü Kalemlik',
              ),
              validator: (v) => v == null || v.isEmpty ? 'Lütfen bir başlık girin' : null,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nihai Satış Fiyatı:'),
                  Text(
                    CurrencyFormatter.formatWithSymbol(
                      widget.result.finalCustomerPrice,
                      sym,
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Geçmişe Kaydet'),
        ),
      ],
    );
  }
}
