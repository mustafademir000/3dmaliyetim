import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const String _currencyKey = 'setting_currency';
  static const String _electricityRateKey = 'setting_elec_rate';
  static const String _isDarkModeKey = 'setting_is_dark';

  String _currencySymbol = 'TL';
  double _defaultElectricityRate = 2.70; // TL per kWh
  bool _isDarkMode = true;

  String get currencySymbol => _currencySymbol;
  double get defaultElectricityRate => _defaultElectricityRate;
  bool get isDarkMode => _isDarkMode;

  AppSettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final rawSymbol = prefs.getString(_currencyKey) ?? 'TL';
    _currencySymbol = rawSymbol == '₺' ? 'TL' : rawSymbol;
    _defaultElectricityRate = prefs.getDouble(_electricityRateKey) ?? 2.70;
    _isDarkMode = prefs.getBool(_isDarkModeKey) ?? true;
    notifyListeners();
  }

  Future<void> setCurrency(String symbol) async {
    _currencySymbol = symbol == '₺' ? 'TL' : symbol;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, _currencySymbol);
  }

  Future<void> setDefaultElectricityRate(double rate) async {
    _defaultElectricityRate = rate;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_electricityRateKey, rate);
  }

  Future<void> toggleTheme(bool isDark) async {
    _isDarkMode = isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDark);
  }
}
