import 'package:flutter/material.dart';

/// Color palette for Project Phoenix.
///
/// Professional, restrained palette designed for adult learners.
/// Colors communicate meaning — never decoration.
///
/// Design rationale:
/// - Primary (Deep Blue): Trust, professionalism, focus
/// - Secondary (Warm Amber): Achievement, warmth, progress
/// - Tertiary (Teal): Growth, success, forward movement
/// - Error (Red): Correction requiring attention (never shame)
abstract final class ColorTokens {
  // ─── Primary ───────────────────────────────────────────────────────
  static const Color primaryLight = Color(0xFF1A237E);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFE8EAF6);
  static const Color onPrimaryContainerLight = Color(0xFF0D1259);

  static const Color primaryDark = Color(0xFF9FA8DA);
  static const Color onPrimaryDark = Color(0xFF0D1259);
  static const Color primaryContainerDark = Color(0xFF283593);
  static const Color onPrimaryContainerDark = Color(0xFFE8EAF6);

  // ─── Secondary ─────────────────────────────────────────────────────
  static const Color secondaryLight = Color(0xFFFF8F00);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFFFF3E0);
  static const Color onSecondaryContainerLight = Color(0xFF4E2600);

  static const Color secondaryDark = Color(0xFFFFD54F);
  static const Color onSecondaryDark = Color(0xFF4E2600);
  static const Color secondaryContainerDark = Color(0xFF5D2F00);
  static const Color onSecondaryContainerDark = Color(0xFFFFF3E0);

  // ─── Tertiary ──────────────────────────────────────────────────────
  static const Color tertiaryLight = Color(0xFF00695C);
  static const Color onTertiaryLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerLight = Color(0xFFE0F2F1);
  static const Color onTertiaryContainerLight = Color(0xFF002420);

  static const Color tertiaryDark = Color(0xFF4DB6AC);
  static const Color onTertiaryDark = Color(0xFF002420);
  static const Color tertiaryContainerDark = Color(0xFF00413B);
  static const Color onTertiaryContainerDark = Color(0xFFE0F2F1);

  // ─── Error ─────────────────────────────────────────────────────────
  static const Color errorLight = Color(0xFFC62828);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color errorContainerLight = Color(0xFFFFEBEE);
  static const Color onErrorContainerLight = Color(0xFF5F0000);

  static const Color errorDark = Color(0xFFEF5350);
  static const Color onErrorDark = Color(0xFF5F0000);
  static const Color errorContainerDark = Color(0xFF7F0000);
  static const Color onErrorContainerDark = Color(0xFFFFEBEE);

  // ─── Surfaces ──────────────────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color onSurfaceLight = Color(0xFF1C1B1F);
  static const Color surfaceVariantLight = Color(0xFFF5F5F5);
  static const Color onSurfaceVariantLight = Color(0xFF49454F);
  static const Color outlineLight = Color(0xFF79747E);
  static const Color outlineVariantLight = Color(0xFFCAC4D0);

  static const Color surfaceDark = Color(0xFF121212);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);
  static const Color surfaceVariantDark = Color(0xFF1E1E1E);
  static const Color onSurfaceVariantDark = Color(0xFFCAC4D0);
  static const Color outlineDark = Color(0xFF938F99);
  static const Color outlineVariantDark = Color(0xFF49454F);

  // ─── Special Purpose ───────────────────────────────────────────────

  /// Success feedback color (pronunciation accepted, answer correct).
  static const Color successLight = Color(0xFF2E7D32);
  static const Color successDark = Color(0xFF66BB6A);

  /// Warning/adjustment color (needs improvement, not wrong).
  static const Color warningLight = Color(0xFFF9A825);
  static const Color warningDark = Color(0xFFFFEE58);

  /// Microphone recording active indicator.
  static const Color recordingActive = Color(0xFFD32F2F);
}
