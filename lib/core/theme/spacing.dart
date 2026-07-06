/// Spacing constants for consistent layout throughout the application.
///
/// Based on an 8px grid system with half-steps at 4px for fine adjustments.
/// All spacing values are multiples of 4 to maintain visual rhythm.
abstract final class Spacing {
  /// 4px — Minimal spacing between tightly related elements.
  static const double xs = 4;

  /// 8px — Spacing between related elements within a group.
  static const double sm = 8;

  /// 12px — Inner padding for compact components.
  static const double md = 12;

  /// 16px — Standard padding for cards, containers.
  static const double lg = 16;

  /// 20px — Spacing between sections within a screen.
  static const double xl = 20;

  /// 24px — Standard margin between major sections.
  static const double xxl = 24;

  /// 32px — Large spacing for visual breathing room.
  static const double xxxl = 32;

  /// 40px — Extra large spacing for screen-level separation.
  static const double huge = 40;

  /// 48px — Minimum touch target size (accessibility).
  static const double touchTarget = 48;

  /// 56px — Standard app bar height.
  static const double appBarHeight = 56;

  /// 80px — Large button / microphone button size.
  static const double largeButton = 80;

  /// Standard horizontal page padding.
  static const double pagePaddingHorizontal = 24;

  /// Standard vertical page padding.
  static const double pagePaddingVertical = 16;

  /// Border radius for cards.
  static const double cardRadius = 16;

  /// Border radius for buttons.
  static const double buttonRadius = 12;

  /// Border radius for small chips/badges.
  static const double chipRadius = 8;
}
