import 'calculation_result.dart';

class HistoryItem {
  final String id;
  final String title;
  final DateTime date;
  final double usedFilamentGrams;
  final double printTimeHours;
  final String filamentName;
  final String printerName;
  final String currencySymbol;
  final CalculationResult result;

  HistoryItem({
    required this.id,
    required this.title,
    required this.date,
    required this.usedFilamentGrams,
    required this.printTimeHours,
    required this.filamentName,
    required this.printerName,
    required this.currencySymbol,
    required this.result,
  });

  HistoryItem copyWith({
    String? title,
    DateTime? date,
    double? usedFilamentGrams,
    double? printTimeHours,
    String? filamentName,
    String? printerName,
    String? currencySymbol,
    CalculationResult? result,
  }) {
    return HistoryItem(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      usedFilamentGrams: usedFilamentGrams ?? this.usedFilamentGrams,
      printTimeHours: printTimeHours ?? this.printTimeHours,
      filamentName: filamentName ?? this.filamentName,
      printerName: printerName ?? this.printerName,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      result: result ?? this.result,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'usedFilamentGrams': usedFilamentGrams,
        'printTimeHours': printTimeHours,
        'filamentName': filamentName,
        'printerName': printerName,
        'currencySymbol': currencySymbol,
        'result': result.toJson(),
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        id: json['id'] as String,
        title: json['title'] as String,
        date: DateTime.parse(json['date'] as String),
        usedFilamentGrams: (json['usedFilamentGrams'] as num).toDouble(),
        printTimeHours: (json['printTimeHours'] as num).toDouble(),
        filamentName: json['filamentName'] as String,
        printerName: json['printerName'] as String,
        currencySymbol: json['currencySymbol'] as String? ?? 'TL',
        result: CalculationResult.fromJson(json['result'] as Map<String, dynamic>),
      );
}
