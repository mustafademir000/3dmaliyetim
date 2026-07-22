import 'package:flutter/material.dart';

import '../../../core/utils/calculator.dart';
import '../models/calculation_result.dart';
import '../models/filament_model.dart';
import '../models/printer_model.dart';

class CalculatorProvider extends ChangeNotifier {
  // Product details
  String _productTitle = '3D Baskı Modeli';

  // Filament parameters
  double _usedFilamentGrams = 150.0;
  double _customFilamentPricePerKg = 650.0; // TL per kg
  bool _useCustomFilament = false;

  // Print time
  int _printTimeHours = 4;
  int _printTimeMinutes = 30;

  // Printer parameters
  double _customPrinterPowerWatts = 200.0;
  double _customHourlyWearCost = 10.0;
  bool _useCustomPrinter = false;

  // Labor & Margins
  double _laborTimeMinutes = 15.0;
  double _laborHourlyRate = 150.0; // TL per hour
  double _failureRiskPercent = 10.0; // %
  double _profitMarginPercent = 40.0; // %

  // Taxes, Marketplace Commission & Cargo
  double _vatPercent = 20.0; // KDV %
  double _commissionPercent = 15.0; // Komisyon % (KDV dahil fiyattan)
  double _cargoCost = 0.0; // Kargo Ücreti TL

  // Getters
  String get productTitle => _productTitle;
  double get usedFilamentGrams => _usedFilamentGrams;
  double get customFilamentPricePerKg => _customFilamentPricePerKg;
  bool get useCustomFilament => _useCustomFilament;

  int get printTimeHours => _printTimeHours;
  int get printTimeMinutes => _printTimeMinutes;
  double get totalPrintTimeHours => _printTimeHours + (_printTimeMinutes / 60.0);

  double get customPrinterPowerWatts => _customPrinterPowerWatts;
  double get customHourlyWearCost => _customHourlyWearCost;
  bool get useCustomPrinter => _useCustomPrinter;

  double get laborTimeMinutes => _laborTimeMinutes;
  double get laborHourlyRate => _laborHourlyRate;
  double get failureRiskPercent => _failureRiskPercent;
  double get profitMarginPercent => _profitMarginPercent;

  double get vatPercent => _vatPercent;
  double get commissionPercent => _commissionPercent;
  double get cargoCost => _cargoCost;

  // Setters
  void setProductTitle(String title) {
    _productTitle = title;
    notifyListeners();
  }

  void setUsedFilamentGrams(double grams) {
    _usedFilamentGrams = grams;
    notifyListeners();
  }

  void setCustomFilamentPricePerKg(double price) {
    _customFilamentPricePerKg = price;
    notifyListeners();
  }

  void setUseCustomFilament(bool value) {
    _useCustomFilament = value;
    notifyListeners();
  }

  void setPrintTimeHours(int hours) {
    _printTimeHours = hours;
    notifyListeners();
  }

  void setPrintTimeMinutes(int minutes) {
    _printTimeMinutes = minutes;
    notifyListeners();
  }

  void setCustomPrinterPowerWatts(double watts) {
    _customPrinterPowerWatts = watts;
    notifyListeners();
  }

  void setCustomHourlyWearCost(double wear) {
    _customHourlyWearCost = wear;
    notifyListeners();
  }

  void setUseCustomPrinter(bool value) {
    _useCustomPrinter = value;
    notifyListeners();
  }

  void setLaborTimeMinutes(double minutes) {
    _laborTimeMinutes = minutes;
    notifyListeners();
  }

  void setLaborHourlyRate(double rate) {
    _laborHourlyRate = rate;
    notifyListeners();
  }

  void setFailureRiskPercent(double percent) {
    _failureRiskPercent = percent;
    notifyListeners();
  }

  void setProfitMarginPercent(double percent) {
    _profitMarginPercent = percent;
    notifyListeners();
  }

  void setVatPercent(double percent) {
    _vatPercent = percent;
    notifyListeners();
  }

  void setCommissionPercent(double percent) {
    _commissionPercent = percent;
    notifyListeners();
  }

  void setCargoCost(double cost) {
    _cargoCost = cost;
    notifyListeners();
  }

  CalculationResult calculate({
    required FilamentModel? selectedFilament,
    required PrinterModel? selectedPrinter,
    required double electricityRatePerKwh,
  }) {
    final filamentKgPrice = _useCustomFilament
        ? _customFilamentPricePerKg
        : (selectedFilament?.pricePerKg ?? _customFilamentPricePerKg);

    final printerPower = _useCustomPrinter
        ? _customPrinterPowerWatts
        : (selectedPrinter?.powerConsumptionWatts ?? _customPrinterPowerWatts);

    final hourlyWear = _useCustomPrinter
        ? _customHourlyWearCost
        : (selectedPrinter?.hourlyWearCost ?? _customHourlyWearCost);

    return Calculator.calculate(
      filamentPricePerKg: filamentKgPrice,
      usedFilamentGrams: _usedFilamentGrams,
      printTimeHours: totalPrintTimeHours,
      printerPowerWatts: printerPower,
      electricityRatePerKwh: electricityRatePerKwh,
      hourlyWearCost: hourlyWear,
      laborTimeMinutes: _laborTimeMinutes,
      laborHourlyRate: _laborHourlyRate,
      failureRiskPercent: _failureRiskPercent,
      profitMarginPercent: _profitMarginPercent,
      vatPercent: _vatPercent,
      commissionPercent: _commissionPercent,
      cargoCost: _cargoCost,
    );
  }
}
