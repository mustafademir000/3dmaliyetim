import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, {String symbol = 'TL', int decimalDigits = 2}) {
    final formattedNumber = NumberFormat('#,##0.00', 'tr_TR').format(amount);
    return '$formattedNumber $symbol';
  }

  static String formatWithSymbol(double amount, String currencySymbol) {
    final sym = (currencySymbol == '₺' || currencySymbol == 'TL') ? 'TL' : currencySymbol;
    final formattedNumber = NumberFormat('#,##0.00', 'tr_TR').format(amount);
    return '$formattedNumber $sym';
  }
}
