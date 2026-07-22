import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings_provider.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController _elecController;

  @override
  void initState() {
    super.initState();
    final currentRate = context.read<AppSettingsProvider>().defaultElectricityRate;
    _elecController = TextEditingController(text: currentRate.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _elecController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    final sym = (settings.currencySymbol == '₺' || settings.currencySymbol == 'TL')
        ? 'TL'
        : settings.currencySymbol;
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Uygulama Ayarları'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Mode Switch
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Karanlık Tema (Dark Mode)'),
              subtitle: const Text('Siyah/Koyu gri görünüm'),
              value: settings.isDarkMode,
              onChanged: (val) {
                context.read<AppSettingsProvider>().toggleTheme(val);
              },
            ),
            const Divider(height: 24),

            // Currency Choice
            Text(
              'Para Birimi:',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'TL', label: Text('TL')),
                ButtonSegment(value: '\$', label: Text('\$ (USD)')),
                ButtonSegment(value: '€', label: Text('€ (EUR)')),
              ],
              selected: {sym},
              onSelectionChanged: (newSelection) {
                context.read<AppSettingsProvider>().setCurrency(newSelection.first);
              },
            ),
            const SizedBox(height: 20),

            // Default Electricity Tariff
            Text(
              'Elektrik Birim Fiyatı (kWh):',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _elecController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: '$sym/kWh',
                hintText: 'Örn: 2.70',
              ),
              onChanged: (val) {
                final rate = double.tryParse(val);
                if (rate != null && rate >= 0) {
                  context.read<AppSettingsProvider>().setDefaultElectricityRate(rate);
                }
              },
            ),
            const SizedBox(height: 4),
            Text(
              'Türkiye ortalama mesken kWh tarifesi ~2.70 $sym\'dir.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tamam'),
        ),
      ],
    );
  }
}
