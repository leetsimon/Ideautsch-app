/// Database configuration constants.
///
/// Defines file names, version numbers, and table names
/// for both the content and user databases.
abstract final class DbConstants {
  /// Content database filename (ships with app, read-only).
  static const String contentDbName = 'phoenix_content.db';

  /// User database filename (created on first launch, read-write).
  static const String userDbName = 'phoenix_user.db';

  /// Current content database schema version.
  static const int contentDbVersion = 1;

  /// Current user database schema version.
  static const int userDbVersion = 1;

  // ─── Content Database Tables ───────────────────────────────────────

  static const String tableMissions = 'missions';
  static const String tableExercises = 'exercises';
  static const String tableVocabulary = 'vocabulary';
  static const String tableMissionVocabulary = 'mission_vocabulary';
  static const String tableConversationTurns = 'conversation_turns';

  // ─── User Database Tables ──────────────────────────────────────────

  static const String tableUserProfile = 'user_profile';
  static const String tableMissionProgress = 'mission_progress';
  static const String tableExerciseAttempts = 'exercise_attempts';
  static const String tableSrsItems = 'srs_items';
  static const String tableDailyStats = 'daily_stats';
}
