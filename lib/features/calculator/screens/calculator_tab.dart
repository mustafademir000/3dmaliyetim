import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../providers/app_settings_provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/filament_provider.dart';
import '../providers/printer_provider.dart';
import '../widgets/cost_result_card.dart';
import '../widgets/save_history_dialog.dart';

class CalculatorTab extends StatefulWidget {
  const CalculatorTab({super.key});

  @override
  State<CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<CalculatorTab> {
  late TextEditingController _titleController;
  late TextEditingController _gramsController;
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late TextEditingController _laborMinsController;
  late TextEditingController _laborRateController;
  late TextEditingController _vatController;
  late TextEditingController _commissionController;
  late TextEditingController _cargoController;

  @override
  void initState() {
    super.initState();
    final calc = context.read<CalculatorProvider>();
    _titleController = TextEditingController(text: calc.productTitle);
    _gramsController = TextEditingController(text: calc.usedFilamentGrams.toStringAsFixed(0));
    _hoursController = TextEditingController(text: calc.printTimeHours.toString());
    _minutesController = TextEditingController(text: calc.printTimeMinutes.toString());
    _laborMinsController = TextEditingController(text: calc.laborTimeMinutes.toStringAsFixed(0));
    _laborRateController = TextEditingController(text: calc.laborHourlyRate.toStringAsFixed(0));
    _vatController = TextEditingController(text: calc.vatPercent.toStringAsFixed(0));
    _commissionController = TextEditingController(text: calc.commissionPercent.toStringAsFixed(0));
    _cargoController = TextEditingController(text: calc.cargoCost.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _gramsController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _laborMinsController.dispose();
    _laborRateController.dispose();
    _vatController.dispose();
    _commissionController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final filamentProv = context.watch<FilamentProvider>();
    final printerProv = context.watch<PrinterProvider>();
    final settings = context.watch<AppSettingsProvider>();

    final result = calc.calculate(
      selectedFilament: filamentProv.selectedFilament,
      selectedPrinter: printerProv.selectedPrinter,
      electricityRatePerKwh: settings.defaultElectricityRate,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 0. Ürün Adı Girişi
          Card(
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Ürün / Model Adı',
                  prefixIcon: Icon(Icons.label_important_rounded),
                  hintText: 'Örn: Ejderha Figürü / Vazo',
                ),
                onChanged: (v) => calc.setProductTitle(v),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 1. Live Result Card Top Highlight
          CostResultCard(
            result: result,
            currencySymbol: settings.currencySymbol,
            onSavePressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final saved = await showDialog<bool>(
                context: context,
                builder: (context) => SaveHistoryDialog(result: result),
              );
              if (saved == true) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Hesaplama geçmişe kaydedildi!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),

          // SECTION TITLE
          _buildSectionHeader('1. Filament & Gramaj Bilgisi', Icons.view_in_ar_rounded),
          const SizedBox(height: 12),

          // Filament Selector Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filament Seçimi',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      ChoiceChip(
                        label: const Text('Özel 1 Kg Fiyatı'),
                        selected: calc.useCustomFilament,
                        onSelected: (val) => calc.setUseCustomFilament(val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (!calc.useCustomFilament) ...[
                    if (filamentProv.filaments.isEmpty)
                      const Text('Kayıtlı filament yok. Presets sekmesinden ekleyin.')
                    else
                      DropdownButtonFormField(
                        initialValue: filamentProv.selectedFilament,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Seçili Filament'),
                        items: filamentProv.filaments.map((f) {
                          return DropdownMenuItem(
                            value: f,
                            child: Text(
                              '${f.brand} - ${f.name} (${f.pricePerKg.toStringAsFixed(0)} TL/kg)',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) filamentProv.selectFilament(val);
                        },
                      ),
                  ] else ...[
                    TextFormField(
                      initialValue: calc.customFilamentPricePerKg.toStringAsFixed(0),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Filament 1 Kg Fiyatı (TL)',
                        suffixText: 'TL/kg',
                        hintText: 'Örn: 650',
                      ),
                      onChanged: (v) {
                        final p = double.tryParse(v);
                        if (p != null) calc.setCustomFilamentPricePerKg(p);
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.scale_rounded, size: 20, color: AppColors.primaryAccent),
                      const SizedBox(width: 8),
                      const Text(
                        'Kullanılan Gramaj:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        '${calc.usedFilamentGrams.toStringAsFixed(0)} gram',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: calc.usedFilamentGrams.clamp(1.0, 2000.0),
                    min: 1.0,
                    max: 1000.0,
                    divisions: 999,
                    label: '${calc.usedFilamentGrams.toStringAsFixed(0)}g',
                    onChanged: (v) {
                      calc.setUsedFilamentGrams(v);
                      _gramsController.text = v.toStringAsFixed(0);
                    },
                  ),
                  TextFormField(
                    controller: _gramsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Hassas Gramaj Girişi (g)',
                      suffixText: 'g',
                    ),
                    onChanged: (v) {
                      final g = double.tryParse(v);
                      if (g != null && g > 0) calc.setUsedFilamentGrams(g);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // SECTION TITLE 2
          _buildSectionHeader('2. Baskı Süresi & Cihaz Seçimi', Icons.timer_rounded),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _hoursController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Baskı Süresi (Saat)',
                            suffixText: 'sa',
                          ),
                          onChanged: (v) {
                            final h = int.tryParse(v);
                            if (h != null && h >= 0) calc.setPrintTimeHours(h);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _minutesController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Dakika',
                            suffixText: 'dk',
                          ),
                          onChanged: (v) {
                            final m = int.tryParse(v);
                            if (m != null && m >= 0 && m < 60) calc.setPrintTimeMinutes(m);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '3D Yazıcı Seçimi',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      ChoiceChip(
                        label: const Text('Özel Cihaz'),
                        selected: calc.useCustomPrinter,
                        onSelected: (val) => calc.setUseCustomPrinter(val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!calc.useCustomPrinter) ...[
                    if (printerProv.printers.isEmpty)
                      const Text('Kayıtlı yazıcı yok.')
                    else
                      DropdownButtonFormField(
                        initialValue: printerProv.selectedPrinter,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Seçili Yazıcı'),
                        items: printerProv.printers.map((p) {
                          return DropdownMenuItem(
                            value: p,
                            child: Text(
                              '${p.name} (${p.powerConsumptionWatts.toStringAsFixed(0)}W)',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) printerProv.selectPrinter(val);
                        },
                      ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: calc.customPrinterPowerWatts.toStringAsFixed(0),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Güç (Watt)',
                              suffixText: 'W',
                            ),
                            onChanged: (v) {
                              final w = double.tryParse(v);
                              if (w != null) calc.setCustomPrinterPowerWatts(w);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: calc.customHourlyWearCost.toStringAsFixed(1),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Aşınma',
                              suffixText: 'TL/sa',
                            ),
                            onChanged: (v) {
                              final c = double.tryParse(v);
                              if (c != null) calc.setCustomHourlyWearCost(c);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // SECTION TITLE 3
          _buildSectionHeader('3. İşçilik, Kâr & Satış Parametreleri', Icons.trending_up_rounded),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _laborMinsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'İşçilik Süresi',
                            suffixText: 'dk',
                            hintText: 'Dilimleme/Temizlik',
                          ),
                          onChanged: (v) {
                            final m = double.tryParse(v);
                            if (m != null && m >= 0) calc.setLaborTimeMinutes(m);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _laborRateController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'İşçilik Saat Ücreti',
                            suffixText: 'TL/saat',
                          ),
                          onChanged: (v) {
                            final r = double.tryParse(v);
                            if (r != null && r >= 0) calc.setLaborHourlyRate(r);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Profit Margin Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hedef Kâr Marjı:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '%${calc.profitMarginPercent.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: calc.profitMarginPercent,
                    min: 0,
                    max: 200,
                    divisions: 200,
                    activeColor: AppColors.secondary,
                    label: '%${calc.profitMarginPercent.toStringAsFixed(0)}',
                    onChanged: (v) => calc.setProfitMarginPercent(v),
                  ),

                  const Divider(height: 24),

                  // KDV, Komisyon (% kdv dahil) & Kargo (TL)
                  const Text(
                    'Vergi, Pazaryeri Komisyonu & Kargo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _vatController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'KDV Oranı (%)',
                            suffixText: '%',
                          ),
                          onChanged: (v) {
                            final p = double.tryParse(v);
                            if (p != null && p >= 0) calc.setVatPercent(p);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _commissionController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Komisyon (%)',
                            suffixText: '%',
                            hintText: 'KDV dahil üzerinden',
                          ),
                          onChanged: (v) {
                            final p = double.tryParse(v);
                            if (p != null && p >= 0) calc.setCommissionPercent(p);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '* Not: Komisyon, KDV dahil ürün fiyatı üzerinden hesaplanır.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cargoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Sabit Kargo Ücreti (TL)',
                      suffixText: 'TL',
                      hintText: 'Örn: 50',
                    ),
                    onChanged: (v) {
                      final c = double.tryParse(v);
                      if (c != null && c >= 0) calc.setCargoCost(c);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
        ),
      ],
    );
  }
}
