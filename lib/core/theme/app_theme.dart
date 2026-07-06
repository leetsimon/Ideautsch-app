import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_tokens.dart';
import 'spacing.dart';
import 'typography_tokens.dart';

/// Application theme configuration.
///
/// Provides both light and dark themes using Material 3 with a
/// professional, minimal aesthetic designed for adult learners.
///
/// The theme is intentionally restrained — no bright primary colors
/// competing for attention. The content (German text, audio feedback,
/// progress) is the visual hero, not the chrome.
abstract final class AppTheme {
  /// Light theme for daytime/well-lit environments.
  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: ColorTokens.primaryLight,
      onPrimary: ColorTokens.onPrimaryLight,
      primaryContainer: ColorTokens.primaryContainerLight,
      onPrimaryContainer: ColorTokens.onPrimaryContainerLight,
      secondary: ColorTokens.secondaryLight,
      onSecondary: ColorTokens.onSecondaryLight,
      secondaryContainer: ColorTokens.secondaryContainerLight,
      onSecondaryContainer: ColorTokens.onSecondaryContainerLight,
      tertiary: ColorTokens.tertiaryLight,
      onTertiary: ColorTokens.onTertiaryLight,
      tertiaryContainer: ColorTokens.tertiaryContainerLight,
      onTertiaryContainer: ColorTokens.onTertiaryContainerLight,
      error: ColorTokens.errorLight,
      onError: ColorTokens.onErrorLight,
      errorContainer: ColorTokens.errorContainerLight,
      onErrorContainer: ColorTokens.onErrorContainerLight,
      surface: ColorTokens.surfaceLight,
      onSurface: ColorTokens.onSurfaceLight,
      surfaceContainerHighest: ColorTokens.surfaceVariantLight,
      onSurfaceVariant: ColorTokens.onSurfaceVariantLight,
      outline: ColorTokens.outlineLight,
      outlineVariant: ColorTokens.outlineVariantLight,
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  /// Dark theme for nighttime/low-light environments.
  static ThemeData dark() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: ColorTokens.primaryDark,
      onPrimary: ColorTokens.onPrimaryDark,
      primaryContainer: ColorTokens.primaryContainerDark,
      onPrimaryContainer: ColorTokens.onPrimaryContainerDark,
      secondary: ColorTokens.secondaryDark,
      onSecondary: ColorTokens.onSecondaryDark,
      secondaryContainer: ColorTokens.secondaryContainerDark,
      onSecondaryContainer: ColorTokens.onSecondaryContainerDark,
      tertiary: ColorTokens.tertiaryDark,
      onTertiary: ColorTokens.onTertiaryDark,
      tertiaryContainer: ColorTokens.tertiaryContainerDark,
      onTertiaryContainer: ColorTokens.onTertiaryContainerDark,
      error: ColorTokens.errorDark,
      onError: ColorTokens.onErrorDark,
      errorContainer: ColorTokens.errorContainerDark,
      onErrorContainer: ColorTokens.onErrorContainerDark,
      surface: ColorTokens.surfaceDark,
      onSurface: ColorTokens.onSurfaceDark,
      surfaceContainerHighest: ColorTokens.surfaceVariantDark,
      onSurfaceVariant: ColorTokens.onSurfaceVariantDark,
      outline: ColorTokens.outlineDark,
      outlineVariant: ColorTokens.outlineVariantDark,
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData _buildTheme(
    ColorScheme colorScheme,
    Brightness brightness,
  ) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      textTheme: TypographyTokens.textTheme(
        baseColor: colorScheme.onSurface,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        color: colorScheme.surface,
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xxl,
            vertical: Spacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.buttonRadius),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xxl,
            vertical: Spacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.buttonRadius),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xxl,
            vertical: Spacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.buttonRadius),
          ),
          side: BorderSide(color: colorScheme.outline),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(Spacing.touchTarget, Spacing.touchTarget),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: colorScheme.surfaceContainerHighest,
        color: colorScheme.primary,
        linearMinHeight: 6,
        borderRadius: BorderRadius.circular(3),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: Spacing.xxl,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
