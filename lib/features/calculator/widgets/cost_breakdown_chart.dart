import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/calculation_result.dart';

class CostBreakdownChart extends StatelessWidget {
  final CalculationResult result;
  final String currencySymbol;

  const CostBreakdownChart({
    super.key,
    required this.result,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTotal = CurrencyFormatter.formatWithSymbol(
      result.totalProductionCost,
      currencySymbol,
    );

    if (result.totalProductionCost <= 0) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text('Hesaplama sonucu 0 $currencySymbol'),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 55,
              startDegreeOffset: -90,
              sections: [
                if (result.filamentCost > 0)
                  PieChartSectionData(
                    color: AppColors.filamentCostColor,
                    value: result.filamentCost,
                    title: '%${result.filamentPercentage.toStringAsFixed(0)}',
                    radius: 26,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                if (result.electricityCost > 0)
                  PieChartSectionData(
                    color: AppColors.electricityCostColor,
                    value: result.electricityCost,
                    title: '%${result.electricityPercentage.toStringAsFixed(0)}',
                    radius: 26,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                if (result.depreciationCost > 0)
                  PieChartSectionData(
                    color: AppColors.depreciationCostColor,
                    value: result.depreciationCost,
                    title: '%${result.depreciationPercentage.toStringAsFixed(0)}',
                    radius: 26,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (result.laborCost > 0)
                  PieChartSectionData(
                    color: AppColors.laborCostColor,
                    value: result.laborCost,
                    title: '%${result.laborPercentage.toStringAsFixed(0)}',
                    radius: 26,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                if (result.failureRiskCost > 0)
                  PieChartSectionData(
                    color: AppColors.riskCostColor,
                    value: result.failureRiskCost,
                    title: '%${result.failurePercentage.toStringAsFixed(0)}',
                    radius: 26,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Maliyet',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                formattedTotal,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
