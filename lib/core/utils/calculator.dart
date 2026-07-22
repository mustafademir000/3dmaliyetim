import '../../features/calculator/models/calculation_result.dart';

class Calculator {
  static CalculationResult calculate({
    required double filamentPricePerKg,
    required double usedFilamentGrams,
    required double printTimeHours,
    required double printerPowerWatts,
    required double electricityRatePerKwh,
    required double hourlyWearCost,
    required double laborTimeMinutes,
    required double laborHourlyRate,
    required double failureRiskPercent,
    required double profitMarginPercent,
    required double vatPercent,
    required double commissionPercent,
    required double cargoCost,
  }) {
    // 1. Filament Cost (gramaj / 1000 * 1kg Fiyatı)
    final filamentCost = (usedFilamentGrams / 1000.0) * filamentPricePerKg;

    // 2. Electricity Cost (Power in Watts -> kW * hours * rate)
    final electricityCost = (printerPowerWatts / 1000.0) * printTimeHours * electricityRatePerKwh;

    // 3. Machine Wear / Depreciation Cost
    final depreciationCost = printTimeHours * hourlyWearCost;

    // 4. Labor Cost (Minutes to Hours)
    final laborCost = (laborTimeMinutes / 60.0) * laborHourlyRate;

    // Subtotal Base Production Cost
    final subtotalBaseCost = filamentCost + electricityCost + depreciationCost + laborCost;

    // 5. Failure Risk Cost
    final failureRiskCost = subtotalBaseCost * (failureRiskPercent / 100.0);

    // Total Production Cost (Base + Risk)
    final totalProductionCost = subtotalBaseCost + failureRiskCost;

    // 6. Profit Amount
    final profitAmount = totalProductionCost * (profitMarginPercent / 100.0);

    // Net Product Price (KDV & Komisyon hariç fiyat)
    final netProductPrice = totalProductionCost + profitAmount;

    // 7. KDV Amount (% olarak)
    final vatAmount = netProductPrice * (vatPercent / 100.0);

    // Price Including KDV
    final priceWithVat = netProductPrice + vatAmount;

    // 8. Commission Amount (% olarak, KDV dahil fiyattan hesaplanır!)
    final commissionAmount = priceWithVat * (commissionPercent / 100.0);

    // 9. Final Customer Price (KDV dahil + Komisyon + Kargo)
    final finalCustomerPrice = priceWithVat + commissionAmount + cargoCost;

    return CalculationResult(
      filamentCost: filamentCost,
      electricityCost: electricityCost,
      depreciationCost: depreciationCost,
      laborCost: laborCost,
      subtotalBaseCost: subtotalBaseCost,
      failureRiskCost: failureRiskCost,
      totalProductionCost: totalProductionCost,
      profitAmount: profitAmount,
      netProductPrice: netProductPrice,
      vatPercent: vatPercent,
      vatAmount: vatAmount,
      priceWithVat: priceWithVat,
      commissionPercent: commissionPercent,
      commissionAmount: commissionAmount,
      cargoCost: cargoCost,
      finalCustomerPrice: finalCustomerPrice,
    );
  }
}
