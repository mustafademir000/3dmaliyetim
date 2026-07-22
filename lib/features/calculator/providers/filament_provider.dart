import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/filament_model.dart';

class FilamentProvider extends ChangeNotifier {
  static const String _storageKey = 'saved_filaments';

  List<FilamentModel> _filaments = [];
  FilamentModel? _selectedFilament;

  List<FilamentModel> get filaments => _filaments;
  FilamentModel? get selectedFilament => _selectedFilament;

  FilamentProvider() {
    _loadFilaments();
  }

  Future<void> _loadFilaments() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _filaments = jsonList.map((e) => FilamentModel.fromJson(e)).toList();
      } catch (e) {
        _filaments = FilamentModel.defaultPresets;
      }
    } else {
      _filaments = FilamentModel.defaultPresets;
    }

    if (_filaments.isNotEmpty) {
      _selectedFilament = _filaments.first;
    }
    notifyListeners();
  }

  Future<void> _saveFilaments() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_filaments.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  void selectFilament(FilamentModel filament) {
    _selectedFilament = filament;
    notifyListeners();
  }

  Future<void> addFilament(FilamentModel filament) async {
    _filaments.add(filament);
    _selectedFilament = filament;
    notifyListeners();
    await _saveFilaments();
  }

  Future<void> updateFilament(FilamentModel updated) async {
    final index = _filaments.indexWhere((element) => element.id == updated.id);
    if (index != -1) {
      _filaments[index] = updated;
      if (_selectedFilament?.id == updated.id) {
        _selectedFilament = updated;
      }
      notifyListeners();
      await _saveFilaments();
    }
  }

  Future<void> deleteFilament(String id) async {
    _filaments.removeWhere((item) => item.id == id);
    if (_selectedFilament?.id == id) {
      _selectedFilament = _filaments.isNotEmpty ? _filaments.first : null;
    }
    notifyListeners();
    await _saveFilaments();
  }
}
