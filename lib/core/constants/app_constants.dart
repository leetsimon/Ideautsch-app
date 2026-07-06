/// Application-wide constants.
///
/// Values that define application behavior and don't belong
/// to any specific feature or layer.
abstract final class AppConstants {
  /// Application display name.
  static const String appName = 'Project Phoenix';

  /// Current application version.
  static const String appVersion = '0.1.0';

  /// Default daily session duration target in minutes.
  static const int defaultDailyGoalMinutes = 25;

  /// Maximum exercises to show in a single review session.
  static const int maxReviewItemsPerSession = 12;

  /// Minimum recording duration in milliseconds to be considered valid.
  static const int minRecordingDurationMs = 500;

  /// Maximum recording duration in milliseconds before auto-stop.
  static const int maxRecordingDurationMs = 30000;

  /// Audio playback speed options.
  static const List<double> playbackSpeeds = [0.7, 0.85, 1.0, 1.15];

  /// Default SRS ease factor for new items.
  static const double defaultEaseFactor = 2.5;

  /// Minimum SRS ease factor (floor).
  static const double minEaseFactor = 1.3;

  /// Maximum SRS interval in days (ceiling).
  static const double maxIntervalDays = 180;
}
