import 'package:flutter/material.dart';

/// Application wide color constants
/// Contains all colors used throughout the app for consistent theming
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary colors
  static const Color primaryBlue = Color(0xFF2C5F8D);
  static const Color darkNavy = Color(0xFF1A3A52);
  
  // Background colors
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color tableHeaderBackground = Color(0xFFE8F4F8);
  static const Color tableRowBackground = Color(0xFFFFFFFF);
  static const Color tableAlternateRowBackground = Color(0xFFF5F5F5);
  
  // Text colors
  static const Color primaryTextColor = Color(0xFF000000);
  static const Color secondaryTextColor = Color(0xFF666666);
  static const Color positiveTextColor = Color(0xFF0066FF);
  static const Color negativeTextColor = Color(0xFFFF0000);
  
  // Border colors
  static const Color borderColor = Color(0xFFDDDDDD);
  static const Color selectedRowBorder = Color(0xFF0066FF);
  
  // Status colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);
  
  // Context menu colors
  static const Color contextMenuBackground = Color(0xFFFFFFFF);
  static const Color contextMenuHover = Color(0xFFE3F2FD);
  
  // Selection colors
  static const Color selectedRowBackground = Color(0xFFE3F2FD);
  static const Color highlightColor = Color(0xFFBBDEFB);
}
