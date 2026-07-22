import 'package:flutter_test/flutter_test.dart';
import 'package:maliyet3d/core/utils/calculator.dart';

void main() {
  test('3D Printing Cost Calculation with KDV, Commission and Cargo test', () {
    // 100g from 1kg filament costing 600 TL = 60 TL filament cost
    // 2 hours print time on a 200W printer with 2.50 TL/kWh elec rate = 0.2kW * 2h * 2.5 = 1 TL elec cost
    // 2 hours print time with 5 TL/hour wear = 10 TL wear cost
    // 30 mins labor at 100 TL/hour = 50 TL labor cost
    // Base cost = 60 + 1 + 10 + 50 = 121 TL
    // Risk = 10% of 121 = 12.1 TL
    // Production cost = 133.1 TL
    // Profit = 30% of 133.1 = 39.93 TL
    // Net Product Price = 133.1 + 39.93 = 173.03 TL
    // KDV = 20% of 173.03 = 34.606 TL
    // Price with KDV = 173.03 + 34.606 = 207.636 TL
    // Commission = 15% of 207.636 (KDV included price) = 31.1454 TL
    // Cargo = 50 TL
    // Final Customer Price = 207.636 + 31.1454 + 50 = 288.7814 TL

    final result = Calculator.calculate(
      filamentPricePerKg: 600.0,
      usedFilamentGrams: 100.0,
      printTimeHours: 2.0,
      printerPowerWatts: 200.0,
      electricityRatePerKwh: 2.50,
      hourlyWearCost: 5.0,
      laborTimeMinutes: 30.0,
      laborHourlyRate: 100.0,
      failureRiskPercent: 10.0,
      profitMarginPercent: 30.0,
      vatPercent: 20.0,
      commissionPercent: 15.0,
      cargoCost: 50.0,
    );

    expect(result.filamentCost, closeTo(60.0, 0.01));
    expect(result.electricityCost, closeTo(1.0, 0.01));
    expect(result.depreciationCost, closeTo(10.0, 0.01));
    expect(result.laborCost, closeTo(50.0, 0.01));
    expect(result.subtotalBaseCost, closeTo(121.0, 0.01));
    expect(result.failureRiskCost, closeTo(12.1, 0.01));
    expect(result.totalProductionCost, closeTo(133.1, 0.01));
    expect(result.profitAmount, closeTo(39.93, 0.01));
    expect(result.netProductPrice, closeTo(173.03, 0.01));
    expect(result.vatAmount, closeTo(34.606, 0.01));
    expect(result.priceWithVat, closeTo(207.636, 0.01));
    expect(result.commissionAmount, closeTo(31.1454, 0.01));
    expect(result.cargoCost, closeTo(50.0, 0.01));
    expect(result.finalCustomerPrice, closeTo(288.7814, 0.01));
  });
}
