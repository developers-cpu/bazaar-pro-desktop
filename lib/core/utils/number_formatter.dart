import 'package:intl/intl.dart';


class NumberFormatter {
  NumberFormatter._();
  
  /// Format number with comma separators
  static String formatWithCommas(num number) {
    final formatter = NumberFormat('#,##,###');
    return formatter.format(number);
  }
  
  /// Format number as price with 2 decimal places
  static String formatPrice(num price) {
    final formatter = NumberFormat('#,##,##0.00');
    return formatter.format(price);
  }
  
  /// Format number as percentage with 2 decimal places
  static String formatPercentage(num percentage) {
    return '${(percentage).toStringAsFixed(2)}%';
  }
  
  /// Format number as integer with comma separators
  static String formatQuantity(int quantity) {
    final formatter = NumberFormat('#,##,###');
    return formatter.format(quantity);
  }
  
  /// Format change value with + or - sign
  static String formatChange(num change) {
    if (change > 0) {
      return '+${change.toStringAsFixed(2)}';
    } else if (change < 0) {
      return change.toStringAsFixed(2);
    }
    return '0.00';
  }
  
  /// Format compact number (K, M, B notation)
  static String formatCompact(num number) {
    final formatter = NumberFormat.compact();
    return formatter.format(number);
  }
  
  /// Parse formatted string to double
  static double? parseFormattedNumber(String formattedNumber) {
    try {
      // Remove commas and parse
      final cleanNumber = formattedNumber.replaceAll(',', '');
      return double.parse(cleanNumber);
    } catch (e) {
      return null;
    }
  }
  
  /// Check if number is positive
  static bool isPositive(num number) => number > 0;
  
  /// Check if number is negative
  static bool isNegative(num number) => number < 0;
  
  /// Check if number is zero
  static bool isZero(num number) => number == 0;
}
