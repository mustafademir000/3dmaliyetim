import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/calculation_result.dart';
import 'cost_breakdown_chart.dart';

class CostResultCard extends StatelessWidget {
  final CalculationResult result;
  final String currencySymbol;
  final VoidCallback onSavePressed;

  const CostResultCard({
    super.key,
    required this.result,
    required this.currencySymbol,
    required this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Maliyet & Fiyat Dökümü',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: onSavePressed,
                  icon: const Icon(Icons.bookmark_add_rounded, size: 20),
                  tooltip: 'Geçmişe Kaydet',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Chart
            CostBreakdownChart(
              result: result,
              currencySymbol: currencySymbol,
            ),
            const SizedBox(height: 20),

            const Divider(height: 1),
            const SizedBox(height: 16),

            // Detailed Cost Rows
            _buildCostRow(
              context,
              label: 'Filament Maliyeti',
              amount: result.filamentCost,
              color: AppColors.filamentCostColor,
              icon: Icons.blur_circular_rounded,
            ),
            _buildCostRow(
              context,
              label: 'Elektrik Maliyeti',
              amount: result.electricityCost,
              color: AppColors.electricityCostColor,
              icon: Icons.bolt_rounded,
            ),
            _buildCostRow(
              context,
              label: 'Cihaz Amortismanı',
              amount: result.depreciationCost,
              color: AppColors.depreciationCostColor,
              icon: Icons.precision_manufacturing_rounded,
            ),
            _buildCostRow(
              context,
              label: 'İşçilik & Son İşlem',
              amount: result.laborCost,
              color: AppColors.laborCostColor,
              icon: Icons.handyman_rounded,
            ),
            _buildCostRow(
              context,
              label: 'Hata / Risk Payı',
              amount: result.failureRiskCost,
              color: AppColors.riskCostColor,
              icon: Icons.warning_amber_rounded,
            ),

            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Net Üretim Maliyeti',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.formatWithSymbol(
                      result.totalProductionCost,
                      currencySymbol,
                    ),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hesaplanan Kâr (+)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  CurrencyFormatter.formatWithSymbol(
                    result.profitAmount,
                    currencySymbol,
                  ),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // KDV & Komisyon & Kargo breakdown
            _buildCostRow(
              context,
              label: 'KDV (%${result.vatPercent.toStringAsFixed(0)})',
              amount: result.vatAmount,
              color: Colors.blueAccent,
              icon: Icons.receipt_long_rounded,
            ),
            _buildCostRow(
              context,
              label: 'Komisyon (%${result.commissionPercent.toStringAsFixed(0)} - KDV Dahil)',
              amount: result.commissionAmount,
              color: Colors.deepOrangeAccent,
              icon: Icons.shopping_bag_rounded,
            ),
            _buildCostRow(
              context,
              label: 'Kargo Ücreti',
              amount: result.cargoCost,
              color: Colors.teal,
              icon: Icons.local_shipping_rounded,
            ),

            const SizedBox(height: 16),

            // Final Selling Price Card Highlight
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'NİHAİ MÜŞTERİ SATIŞ FİYATI',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'KDV + Komisyon + Kargo Dahil',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    CurrencyFormatter.formatWithSymbol(
                      result.finalCustomerPrice,
                      currencySymbol,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(
    BuildContext context, {
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              ),
            ),
          ),
          Text(
            CurrencyFormatter.formatWithSymbol(amount, currencySymbol),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
