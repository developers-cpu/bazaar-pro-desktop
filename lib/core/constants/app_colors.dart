import 'package:flutter/material.dart';

// ============================================================================
// LIGHT THEME COLORS
// ============================================================================

class LightThemeColors {
  LightThemeColors._();

  // Background Colors
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color inputFieldBackground = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Primary & Secondary Colors
  static const Color primaryColor = Color(0xFF1F4A66);
  static const Color secondaryColor = Color(0xFFFF0000);

  // Text Colors
  static const Color textColor = Color(0xFF1F4A66);
  static const Color supportiveTextColor = Color(0xFF788088);

  // Border & Divider Colors
  static const Color cardBorderColor = Color(0xFFE9E9E9);
  static const Color dividerColor = Color(0xFFE9E9E9);

  // Table Colors
  static const Color tableBackground = Color(0xFFEDEDED);
  static const Color tableColumnHeadColor = Color(0xFFC6DBE8);
  static const Color tableRowBackground = Color(0xFFFFFFFF);
  static const Color tableAlternateRowBackground = Color(0xFFF5F5F5);

  // Chip Colors - Blue
  static const Color chipTextBlueColor = Color(0xFF0051FF);
  static const Color chipBgBlue = Color(0xFFDFECFE);

  // Chip Colors - Red
  static const Color chipTextRedColor = Color(0xFFE05E50);
  static const Color chipBgRed = Color(0xFFFBE7E4);

  // Selection Colors
  static const Color selectedRowBackground = Color(0xFFE3F2FD);
  static const Color highlightColor = Color(0xFFBBDEFB);
  static const Color selectedRowBorder = Color(0xFF0066FF);

  // Context Menu Colors
  static const Color contextMenuBackground = Color(0xFFFFFFFF);
  static const Color contextMenuHover = Color(0xFFE3F2FD);

  // Positive/Negative Colors
  static const Color positiveTextColor = Color(0xFF0066FF);
  static const Color negativeTextColor = Color(0xFFFF0000);

  // Gradient Colors (for reference - gradients need to be built separately)
  static const Color gradientPrimaryColor = Color(0xFF368AE9);
  static const Color gradientBaseColor = Color(0xFFFFFFFF);
}

// ============================================================================
// DARK THEME COLORS
// ============================================================================

class DarkThemeColors {
  DarkThemeColors._();

  // Background Colors
  static const Color backgroundColor = Color(0xFF0D0D0D);
  static const Color inputFieldBackground = Color(0xFF0D0D0D);
  static const Color cardBackground = Color(0xFF1C1C1C);

  // Primary & Secondary Colors
  static const Color primaryColor = Color(0xFF1F4A66);

  static const Color secondaryColor = Color(0xFFE05E50);

  // Text Colors
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color supportiveTextColor = Color(0xFFA1A9B1);

  // Border & Divider Colors
  static const Color cardBorderColor = Color(0xFF494949);
  static const Color dividerColor = Color(0xFF494949);

  // Table Colors
  static const Color tableBackground = Color(0xFF282829);
  static const Color tableColumnHeadColor = Color(0xFF232E3D);
  static const Color tableRowBackground = Color(0xFF1C1C1C);
  static const Color tableAlternateRowBackground = Color(0xFF282829);

  // Chip Colors - Blue
  static const Color chipTextBlueColor = Color(0xFF1F4A66);
  static const Color chipBgBlue = Color(0xFF162032);

  // Chip Colors - Red
  static const Color chipTextRedColor = Color(0xFFE05E50);
  static const Color chipBgRed = Color(0xFF2B1A1A);

  // Selection Colors
  static const Color selectedRowBackground = Color(0xFF162032);
  static const Color highlightColor = Color(0xFF232E3D);
  static const Color selectedRowBorder = Color(0xFF1F4A66);

  // Context Menu Colors
  static const Color contextMenuBackground = Color(0xFF1C1C1C);
  static const Color contextMenuHover = Color(0xFF162032);

  // Positive/Negative Colors
  static const Color positiveTextColor = Color(0xFF1F4A66);
  static const Color negativeTextColor = Color(0xFFE05E50);

  // Gradient Colors (for reference - gradients need to be built separately)
  static const Color gradientPrimaryColor = Color(0xFF1F4A66);
  static const Color gradientBaseColor = Color(0xFF0D0D0D);
}

// ============================================================================
// APP COLORS - Main Access Class with Theme Support
// ============================================================================

class AppColors {
  AppColors._();

  // Primary colors (for ThemeData)
  static const Color primaryBlue = Color(0xFF1F4A66);
  static const Color darkNavy = Color(0xFF1A3A52);

  // Background colors (static - for const contexts)
  static const Color backgroundColorLight = Color(0xFFFFFFFF);
  static const Color tableHeaderBackground = Color(0xFFC6DBE8);
  static const Color tableRowBackground = Color(0xFFFFFFFF);
  static const Color tableAlternateRowBackground = Color(0xFFF5F5F5);

  // Text colors (static - for const contexts)
  static const Color primaryTextColor = Color(0xFF1F4A66);
  static const Color secondaryTextColor = Color(0xFF788088);
  static const Color positiveTextColor = Color(0xFF0066FF);
  static const Color negativeTextColor = Color(0xFFFF0000);

  // Border colors (static)
  static const Color borderColor = Color(0xFFE9E9E9);
  static const Color selectedRowBorder = Color(0xFF0066FF);

  // Status colors (Common for both themes)
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Context menu colors (static)
  static const Color contextMenuBackground = Color(0xFFFFFFFF);
  static const Color contextMenuHover = Color(0xFFE3F2FD);

  // Selection colors (static)
  static const Color selectedRowBackground = Color(0xFFE3F2FD);
  static const Color highlightColor = Color(0xFFBBDEFB);

  // Common Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // -------------------------------------------------------------------------
  // Theme Detection Helper
  // -------------------------------------------------------------------------
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // -------------------------------------------------------------------------
  // THEME-AWARE COLOR GETTERS
  // Use these when you have BuildContext available
  // -------------------------------------------------------------------------

  // Background Colors
  static Color backgroundColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.backgroundColor
        : LightThemeColors.backgroundColor;
  }

  static Color inputFieldBackground(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.inputFieldBackground
        : LightThemeColors.inputFieldBackground;
  }

  static Color cardBackground(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.cardBackground
        : LightThemeColors.cardBackground;
  }

  // Primary & Secondary Colors
  static Color primaryColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.primaryColor
        : LightThemeColors.primaryColor;
  }

  static Color secondaryColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.secondaryColor
        : LightThemeColors.secondaryColor;
  }

  // Text Colors
  static Color textColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.textColor
        : LightThemeColors.textColor;
  }

  static Color supportiveTextColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.supportiveTextColor
        : LightThemeColors.supportiveTextColor;
  }

  // Border & Divider Colors
  static Color cardBorderColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.cardBorderColor
        : LightThemeColors.cardBorderColor;
  }

  static Color dividerColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.dividerColor
        : LightThemeColors.dividerColor;
  }

  // Table Colors
  static Color tableBackground(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.tableBackground
        : LightThemeColors.tableBackground;
  }

  static Color tableColumnHeadColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.tableColumnHeadColor
        : LightThemeColors.tableColumnHeadColor;
  }

  static Color getTableRowBackground(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.tableRowBackground
        : LightThemeColors.tableRowBackground;
  }

  static Color getTableAlternateRowBackground(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.tableAlternateRowBackground
        : LightThemeColors.tableAlternateRowBackground;
  }

  // Chip Colors - Blue
  static Color chipTextBlueColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.chipTextBlueColor
        : LightThemeColors.chipTextBlueColor;
  }

  static Color chipBgBlue(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.chipBgBlue
        : LightThemeColors.chipBgBlue;
  }

  // Chip Colors - Red
  static Color chipTextRedColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.chipTextRedColor
        : LightThemeColors.chipTextRedColor;
  }

  static Color chipBgRed(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.chipBgRed
        : LightThemeColors.chipBgRed;
  }

  // Selection Colors
  static Color getSelectedRowBackground(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.selectedRowBackground
        : LightThemeColors.selectedRowBackground;
  }

  static Color getHighlightColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.highlightColor
        : LightThemeColors.highlightColor;
  }

  static Color getSelectedRowBorder(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.selectedRowBorder
        : LightThemeColors.selectedRowBorder;
  }

  // Context Menu Colors
  static Color getContextMenuBackground(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.contextMenuBackground
        : LightThemeColors.contextMenuBackground;
  }

  static Color getContextMenuHover(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.contextMenuHover
        : LightThemeColors.contextMenuHover;
  }

  // Positive/Negative Colors
  static Color getPositiveTextColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.positiveTextColor
        : LightThemeColors.positiveTextColor;
  }

  static Color getNegativeTextColor(BuildContext context) {
    return isDarkMode(context)
        ? DarkThemeColors.negativeTextColor
        : LightThemeColors.negativeTextColor;
  }

  // -------------------------------------------------------------------------
  // Gradient Builders
  // -------------------------------------------------------------------------

  /// Input Field Gradient (Dark mode only - Light mode uses solid color)
  static Decoration inputFieldDecoration(BuildContext context) {
    if (isDarkMode(context)) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            DarkThemeColors.inputFieldBackground,
            DarkThemeColors.inputFieldBackground.withOpacity(0.95),
            const Color(0xFF368AE9).withOpacity(0.2),
          ],
          stops: const [0.0, 0.64, 1.0],
        ),
      );
    }
    return const BoxDecoration(
      color: LightThemeColors.inputFieldBackground,
    );
  }

  /// Collapse Card Gradient
  static LinearGradient collapseCardGradient(BuildContext context) {
    final baseColor = isDarkMode(context)
        ? DarkThemeColors.gradientBaseColor
        : LightThemeColors.gradientBaseColor;

    return LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [
        baseColor,
        const Color(0xFF368AE9).withOpacity(0.15),
        const Color(0xFF368AE9).withOpacity(0.4),
      ],
      stops: const [0.0, 0.64, 1.0],
    );
  }

  /// Login Screen Background Gradient
  static LinearGradient loginScreenBgGradient(BuildContext context) {
    final baseColor = isDarkMode(context)
        ? DarkThemeColors.gradientBaseColor
        : LightThemeColors.gradientBaseColor;

    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        baseColor,
        const Color(0xFF368AE9).withOpacity(0.05),
        const Color(0xFF368AE9).withOpacity(0.2),
      ],
      stops: const [0.0, 0.64, 1.0],
    );
  }
}