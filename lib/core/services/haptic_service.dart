import 'package:flutter/services.dart';

/// Provides contextual haptic feedback for key user interactions.
///
/// Haptics are subtle — the learner should FEEL the app responding
/// without consciously noticing vibrations. Used for:
/// - Button presses (light tap)
/// - Recording start/stop (medium impact)
/// - Success feedback (success pattern)
/// - Error/retry (warning pattern)
/// - Mission complete (celebration)
///
/// On Windows, haptics are no-ops (no vibration hardware).
/// Respects system accessibility settings automatically.
abstract final class HapticService {
  /// Light tap — button presses, option selection.
  static Future<void> lightTap() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact — recording start, important transitions.
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact — mission complete, major milestones.
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection tick — scrolling through options, page changes.
  static Future<void> selectionTick() async {
    await HapticFeedback.selectionClick();
  }

  /// Success pattern — correct answer, exercise passed.
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Warning pattern — retry needed, partial success.
  static Future<void> warning() async {
    await HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact();
  }

  /// Recording started — confirms mic is active.
  static Future<void> recordingStart() async {
    await HapticFeedback.mediumImpact();
  }

  /// Recording stopped — confirms capture complete.
  static Future<void> recordingStop() async {
    await HapticFeedback.lightImpact();
  }

  /// Mission complete celebration.
  static Future<void> celebration() async {
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }
}
