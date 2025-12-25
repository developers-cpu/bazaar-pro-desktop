import 'package:intl/intl.dart';

/// Utility class for formatting dates throughout the application
/// Provides consistent date formatting across the app
class DateFormatter {
  // Prevent instantiation
  DateFormatter._();
  
  /// Format date to DD/MM/YY format
  /// Example: 25/11/25
  static String formatToShortDate(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }
  
  /// Format date to DD/MM/YYYY format
  /// Example: 25/11/2025
  static String formatToFullDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  /// Format date with time to DD/MM/YY HH:mm:ss format
  /// Example: 25/11/25 10:36:55
  static String formatToDateTime(DateTime date) {
    return DateFormat('dd/MM/yy HH:mm:ss').format(date);
  }
  
  /// Format date with time and AM/PM to DD/MM/YY hh:mm:ss a format
  /// Example: 12/11/25 10:36:55 AM
  static String formatToDateTimeWithAmPm(DateTime date) {
    return DateFormat('dd/MM/yy hh:mm:ss a').format(date);
  }
  
  /// Format time only to HH:mm:ss format
  /// Example: 10:36:55
  static String formatToTime(DateTime date) {
    return DateFormat('HH:mm:ss').format(date);
  }
  
  /// Parse string date in DD/MM/YY format to DateTime
  static DateTime? parseShortDate(String dateString) {
    try {
      return DateFormat('dd/MM/yy').parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  /// Parse string date in DD/MM/YYYY format to DateTime
  static DateTime? parseFullDate(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
