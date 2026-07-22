import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/printer_model.dart';

class PrinterProvider extends ChangeNotifier {
  static const String _storageKey = 'saved_printers';

  List<PrinterModel> _printers = [];
  PrinterModel? _selectedPrinter;

  List<PrinterModel> get printers => _printers;
  PrinterModel? get selectedPrinter => _selectedPrinter;

  PrinterProvider() {
    _loadPrinters();
  }

  Future<void> _loadPrinters() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _printers = jsonList.map((e) => PrinterModel.fromJson(e)).toList();
      } catch (e) {
        _printers = PrinterModel.defaultPresets;
      }
    } else {
      _printers = PrinterModel.defaultPresets;
    }

    if (_printers.isNotEmpty) {
      _selectedPrinter = _printers.first;
    }
    notifyListeners();
  }

  Future<void> _savePrinters() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_printers.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  void selectPrinter(PrinterModel printer) {
    _selectedPrinter = printer;
    notifyListeners();
  }

  Future<void> addPrinter(PrinterModel printer) async {
    _printers.add(printer);
    _selectedPrinter = printer;
    notifyListeners();
    await _savePrinters();
  }

  Future<void> updatePrinter(PrinterModel updated) async {
    final index = _printers.indexWhere((element) => element.id == updated.id);
    if (index != -1) {
      _printers[index] = updated;
      if (_selectedPrinter?.id == updated.id) {
        _selectedPrinter = updated;
      }
      notifyListeners();
      await _savePrinters();
    }
  }

  Future<void> deletePrinter(String id) async {
    _printers.removeWhere((item) => item.id == id);
    if (_selectedPrinter?.id == id) {
      _selectedPrinter = _printers.isNotEmpty ? _printers.first : null;
    }
    notifyListeners();
    await _savePrinters();
  }
}
