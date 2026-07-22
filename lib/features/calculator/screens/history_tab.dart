import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/history_item.dart';
import '../providers/history_provider.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProv = context.watch<HistoryProvider>();

    if (historyProv.history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.bookmark_border_rounded, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Henüz kaydedilmiş bir teklif yok.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Hesaplama sekmesinden "Kaydet" butonu ile ekleyebilirsiniz.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Kaydedilenler (${historyProv.history.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: 'Tümünü Temizle',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Tüm Kayıtları Temizle'),
                  content: const Text('Tüm kaydedilmiş teklifler silinecek. Emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('İptal'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        context.read<HistoryProvider>().clearHistory();
                        Navigator.pop(context);
                      },
                      child: const Text('Tümünü Sil', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyProv.history.length,
        itemBuilder: (context, index) {
          final item = historyProv.history[index];
          final dateStr = DateFormat('dd.MM.yyyy HH:mm').format(item.date);
          final sym = item.currencySymbol == '₺' ? 'TL' : item.currencySymbol;
          final profitPercent = item.result.profitMarginPercent.toStringAsFixed(0);
          final profitAmountStr = CurrencyFormatter.formatWithSymbol(item.result.profitAmount, sym);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _showDetailsModal(context, item),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryAccent],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            CurrencyFormatter.formatWithSymbol(
                              item.result.finalCustomerPrice,
                              sym,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.usedFilamentGrams.toStringAsFixed(0)}g (${item.filamentName}) • ${item.printTimeHours.toStringAsFixed(1)} saat (${item.printerName})',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8),

                    // Profit Row Highlight
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up_rounded, size: 16, color: AppColors.secondary),
                          const SizedBox(width: 6),
                          Text(
                            'Kâr Oranı: %$profitPercent ($profitAmountStr)',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateStr,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_note_rounded, color: AppColors.primaryAccent),
                              tooltip: 'İsmi Düzenle',
                              onPressed: () => _showEditTitleDialog(context, item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                              tooltip: 'Sil',
                              onPressed: () {
                                historyProv.deleteItem(item.id);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditTitleDialog(BuildContext context, HistoryItem item) {
    final controller = TextEditingController(text: item.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ürün İsmini Düzenle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Ürün / Model Adı',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                final updated = item.copyWith(title: newTitle);
                context.read<HistoryProvider>().updateItem(updated);
              }
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showDetailsModal(BuildContext context, HistoryItem item) {
    final res = item.result;
    final sym = item.currencySymbol == '₺' ? 'TL' : item.currencySymbol;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Filament Maliyeti', res.filamentCost, sym),
              _buildDetailRow('Elektrik Maliyeti', res.electricityCost, sym),
              _buildDetailRow('Cihaz Amortismanı', res.depreciationCost, sym),
              _buildDetailRow('İşçilik Maliyeti', res.laborCost, sym),
              _buildDetailRow('Hata Payı', res.failureRiskCost, sym),
              const Divider(height: 16),
              _buildDetailRow('Net Üretim Maliyeti', res.totalProductionCost, sym, isBold: true),
              _buildDetailRow(
                'Kâr Oranı (%${res.profitMarginPercent.toStringAsFixed(0)})',
                res.profitAmount,
                sym,
                isBold: true,
                color: AppColors.secondary,
              ),
              const Divider(height: 16),
              _buildDetailRow('KDV (%${res.vatPercent.toStringAsFixed(0)})', res.vatAmount, sym),
              _buildDetailRow('Komisyon (%${res.commissionPercent.toStringAsFixed(0)})', res.commissionAmount, sym),
              _buildDetailRow('Kargo Ücreti', res.cargoCost, sym),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nihai Müşteri Satış Fiyatı',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      CurrencyFormatter.formatWithSymbol(res.finalCustomerPrice, sym),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, double amount, String sym, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            CurrencyFormatter.formatWithSymbol(amount, sym),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
