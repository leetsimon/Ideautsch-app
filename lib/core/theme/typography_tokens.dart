import 'package:flutter/material.dart';

/// Typography scale for Project Phoenix.
///
/// Uses Inter as the primary typeface for its excellent readability
/// at all sizes and its professional, clean aesthetic.
///
/// German text is rendered slightly larger than UI text for clarity,
/// particularly for learners who are still building reading fluency.
abstract final class TypographyTokens {
  static const String _fontFamily = 'Inter';
  static const String _arabicFontFamily = 'NotoSansArabic';

  /// Creates the complete text theme for the application.
  static TextTheme textTheme({required Color baseColor}) {
    return TextTheme(
      // Display — Module titles, large headings
      displayLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: baseColor,
      ),
      displayMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        height: 1.2,
        color: baseColor,
      ),
      displaySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.3,
        color: baseColor,
      ),

      // Headline — Section headers, mission titles
      headlineLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.3,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
        color: baseColor,
      ),

      // Title — Card titles, navigation labels
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.4,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.4,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
        color: baseColor,
      ),

      // Body — Content text, explanations, descriptions
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.5,
        color: baseColor,
      ),
      bodySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.5,
        color: baseColor,
      ),

      // Label — Buttons, chips, small UI elements
      labelLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
        color: baseColor,
      ),
      labelSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
        color: baseColor,
      ),
    );
  }

  /// Text style for German learning content (slightly larger).
  static TextStyle germanContent({
    required Color color,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.15,
      height: 1.5,
      color: color,
    );
  }

  /// Text style for Arabic/Darija content.
  static TextStyle arabicContent({
    required Color color,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontFamily: _arabicFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 1.6,
      color: color,
    );
  }

  /// Text style for phonetic IPA transcriptions.
  static TextStyle phonetic({
    required Color color,
    double fontSize = 14,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      letterSpacing: 0.5,
      height: 1.4,
      color: color,
    );
  }
}
