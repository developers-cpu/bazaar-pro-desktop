import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Application theme configuration
/// Provides light and dark theme with Google Fonts Open Sans
class AppTheme {
  AppTheme._();

  /// Build Light Theme with Google Fonts Open Sans
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: LightThemeColors.primaryColor,
      scaffoldBackgroundColor: LightThemeColors.backgroundColor,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: LightThemeColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: GoogleFonts.openSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Text Theme with Open Sans
      textTheme: GoogleFonts.openSansTextTheme(
        TextTheme(
          // Display styles
          displayLarge: GoogleFonts.openSans(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            color: LightThemeColors.textColor,
          ),
          displayMedium: GoogleFonts.openSans(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            color: LightThemeColors.textColor,
          ),
          displaySmall: GoogleFonts.openSans(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: LightThemeColors.textColor,
          ),

          // Headline styles
          headlineLarge: GoogleFonts.openSans(
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: LightThemeColors.textColor,
          ),
          headlineMedium: GoogleFonts.openSans(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: LightThemeColors.textColor,
          ),
          headlineSmall: GoogleFonts.openSans(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: LightThemeColors.textColor,
          ),

          // Title styles
          titleLarge: GoogleFonts.openSans(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: LightThemeColors.textColor,
          ),
          titleMedium: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: LightThemeColors.textColor,
          ),
          titleSmall: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: LightThemeColors.textColor,
          ),

          // Body styles
          bodyLarge: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: LightThemeColors.textColor,
          ),
          bodyMedium: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: LightThemeColors.textColor,
          ),
          bodySmall: GoogleFonts.openSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: LightThemeColors.textColor,
          ),

          // Label styles
          labelLarge: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: LightThemeColors.textColor,
          ),
          labelMedium: GoogleFonts.openSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: LightThemeColors.textColor,
          ),
          labelSmall: GoogleFonts.openSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: LightThemeColors.textColor,
          ),
        ),
      ),

      iconTheme: const IconThemeData(color: Colors.white),

      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: LightThemeColors.primaryColor,
        primary: LightThemeColors.primaryColor,
        secondary: LightThemeColors.primaryColor,
        surface: LightThemeColors.backgroundColor,
      ),

      cardColor: LightThemeColors.cardBackground,
      dividerColor: LightThemeColors.dividerColor,
    );
  }

  /// Build Dark Theme with Google Fonts Open Sans
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: DarkThemeColors.primaryColor,
      scaffoldBackgroundColor: DarkThemeColors.backgroundColor,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: DarkThemeColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: GoogleFonts.openSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Text Theme with Open Sans
      textTheme: GoogleFonts.openSansTextTheme(
        TextTheme(
          // Display styles
          displayLarge: GoogleFonts.openSans(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            color: DarkThemeColors.textColor,
          ),
          displayMedium: GoogleFonts.openSans(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            color: DarkThemeColors.textColor,
          ),
          displaySmall: GoogleFonts.openSans(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: DarkThemeColors.textColor,
          ),

          // Headline styles
          headlineLarge: GoogleFonts.openSans(
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: DarkThemeColors.textColor,
          ),
          headlineMedium: GoogleFonts.openSans(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: DarkThemeColors.textColor,
          ),
          headlineSmall: GoogleFonts.openSans(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: DarkThemeColors.textColor,
          ),

          // Title styles
          titleLarge: GoogleFonts.openSans(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: DarkThemeColors.textColor,
          ),
          titleMedium: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: DarkThemeColors.textColor,
          ),
          titleSmall: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: DarkThemeColors.textColor,
          ),

          // Body styles
          bodyLarge: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: DarkThemeColors.textColor,
          ),
          bodyMedium: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: DarkThemeColors.textColor,
          ),
          bodySmall: GoogleFonts.openSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: DarkThemeColors.textColor,
          ),

          // Label styles
          labelLarge: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: DarkThemeColors.textColor,
          ),
          labelMedium: GoogleFonts.openSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: DarkThemeColors.textColor,
          ),
          labelSmall: GoogleFonts.openSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: DarkThemeColors.textColor,
          ),
        ),
      ),

      iconTheme: const IconThemeData(color: Colors.white),

      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: DarkThemeColors.primaryColor,
        primary: DarkThemeColors.primaryColor,
        secondary: DarkThemeColors.primaryColor,
        surface: DarkThemeColors.backgroundColor,
      ),

      cardColor: DarkThemeColors.cardBackground,
      dividerColor: DarkThemeColors.dividerColor,
    );
  }
}