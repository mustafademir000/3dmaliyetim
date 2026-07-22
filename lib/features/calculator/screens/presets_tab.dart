import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../models/filament_model.dart';
import '../models/printer_model.dart';
import '../providers/app_settings_provider.dart';
import '../providers/filament_provider.dart';
import '../providers/printer_provider.dart';
import '../widgets/filament_dialog.dart';
import '../widgets/printer_dialog.dart';

class PresetsTab extends StatelessWidget {
  const PresetsTab({super.key});

  void _openFilamentDialog(BuildContext context, [FilamentModel? item]) {
    showDialog(
      context: context,
      builder: (context) => FilamentDialog(filamentToEdit: item),
    );
  }

  void _openPrinterDialog(BuildContext context, [PrinterModel? item]) {
    showDialog(
      context: context,
      builder: (context) => PrinterDialog(printerToEdit: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context.watch<AppSettingsProvider>().currencySymbol;
    final filamentProv = context.watch<FilamentProvider>();
    final printerProv = context.watch<PrinterProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.blur_circular_rounded), text: 'Filamentler'),
            Tab(icon: Icon(Icons.precision_manufacturing_rounded), text: 'Yazıcılar'),
          ],
        ),
        body: TabBarView(
          children: [
            // FILAMENTS TAB
            _buildFilamentsView(context, filamentProv, currencySymbol),
            // PRINTERS TAB
            _buildPrintersView(context, printerProv, currencySymbol),
          ],
        ),
      ),
    );
  }

  Widget _buildFilamentsView(
    BuildContext context,
    FilamentProvider provider,
    String currencySymbol,
  ) {
    if (provider.filaments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.blur_circular_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Henüz kayıtlı filament yok.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openFilamentDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Filament Ekle'),
            )
          ],
        ),
      );
    }

    final sym = currencySymbol == '₺' ? 'TL' : currencySymbol;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openFilamentDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Filament Ekle'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: provider.filaments.length,
        itemBuilder: (context, index) {
          final f = provider.filaments[index];
          final isSelected = provider.selectedFilament?.id == f.id;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isSelected ? AppColors.primaryAccent : Colors.transparent,
                width: isSelected ? 2 : 0,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.blur_circular_rounded, color: AppColors.primaryAccent, size: 20),
              ),
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      f.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      f.materialType,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${f.brand} • 1 Kg Fiyatı: ${f.pricePerKg.toStringAsFixed(0)} $sym',
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${f.pricePerKg.toStringAsFixed(0)} $sym/kg',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    onSelected: (val) {
                      if (val == 'edit') {
                        _openFilamentDialog(context, f);
                      } else if (val == 'delete') {
                        provider.deleteFilament(f.id);
                      } else if (val == 'select') {
                        provider.selectFilament(f);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'select', child: Text('Hesaplayıcıda Seç')),
                      const PopupMenuItem(value: 'edit', child: Text('Düzenle')),
                      const PopupMenuItem(value: 'delete', child: Text('Sil', style: TextStyle(color: Colors.red))),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrintersView(
    BuildContext context,
    PrinterProvider provider,
    String currencySymbol,
  ) {
    if (provider.printers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.precision_manufacturing_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Henüz kayıtlı 3D yazıcı yok.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openPrinterDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Yazıcı Ekle'),
            )
          ],
        ),
      );
    }

    final sym = currencySymbol == '₺' ? 'TL' : currencySymbol;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openPrinterDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Yazıcı Ekle'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: provider.printers.length,
        itemBuilder: (context, index) {
          final p = provider.printers[index];
          final isSelected = provider.selectedPrinter?.id == p.id;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isSelected ? AppColors.primaryAccent : Colors.transparent,
                width: isSelected ? 2 : 0,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentAmber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.precision_manufacturing_rounded, color: AppColors.accentAmber, size: 20),
              ),
              title: Text(
                p.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Güç: ${p.powerConsumptionWatts.toStringAsFixed(0)}W • Amortisman: ${p.hourlyWearCost.toStringAsFixed(1)} $sym/saat',
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              trailing: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                iconSize: 20,
                onSelected: (val) {
                  if (val == 'edit') {
                    _openPrinterDialog(context, p);
                  } else if (val == 'delete') {
                    provider.deletePrinter(p.id);
                  } else if (val == 'select') {
                    provider.selectPrinter(p);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'select', child: Text('Hesaplayıcıda Seç')),
                  const PopupMenuItem(value: 'edit', child: Text('Düzenle')),
                  const PopupMenuItem(value: 'delete', child: Text('Sil', style: TextStyle(color: Colors.red))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
