import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class HistoryProvider extends ChangeNotifier {
  static const String _storageKey = 'saved_calculation_history';

  List<HistoryItem> _history = [];

  List<HistoryItem> get history => _history;

  HistoryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _history = jsonList.map((e) => HistoryItem.fromJson(e)).toList();
        _history.sort((a, b) => b.date.compareTo(a.date));
      } catch (e) {
        _history = [];
      }
    }
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_history.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> addItem(HistoryItem item) async {
    _history.insert(0, item);
    notifyListeners();
    await _saveHistory();
  }

  Future<void> updateItem(HistoryItem updatedItem) async {
    final index = _history.indexWhere((element) => element.id == updatedItem.id);
    if (index != -1) {
      _history[index] = updatedItem;
      notifyListeners();
      await _saveHistory();
    }
  }

  Future<void> deleteItem(String id) async {
    _history.removeWhere((element) => element.id == id);
    notifyListeners();
    await _saveHistory();
  }

  Future<void> clearHistory() async {
    _history.clear();
    notifyListeners();
    await _saveHistory();
  }
}
