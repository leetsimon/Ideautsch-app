import '../../domain/entities/user_progress.dart';

/// Data model for UserProgress — assembles from multiple DB queries.
///
/// UserProgress is not stored as a single row. It's computed from
/// multiple tables: mission_progress, srs_items, daily_stats,
/// career_readiness. This model handles that assembly.
class UserProgressModel {
  const UserProgressModel._();

  /// Assemble a [UserProgress] entity from multiple data sources.
  static UserProgress fromQueryResults({
    required int missionsCompleted,
    required int totalSpeakingTimeSeconds,
    required int vocabularyLearned,
    required int vocabularyMastered,
    required Map<String, double> careerScores,
    required int currentStreak,
    required int longestStreak,
    required int totalSessions,
    required int currentModule,
    required DateTime lastActiveDate,
  }) {
    return UserProgress(
      missionsCompleted: missionsCompleted,
      totalSpeakingTimeSeconds: totalSpeakingTimeSeconds,
      vocabularyLearned: vocabularyLearned,
      vocabularyMastered: vocabularyMastered,
      careerReadiness: CareerReadiness(
        phoneCommunication:
            careerScores['phone_communication'] ?? 0.0,
        customerHandling:
            careerScores['customer_handling'] ?? 0.0,
        professionalLanguage:
            careerScores['professional_language'] ?? 0.0,
        speakingFluency:
            careerScores['speaking_fluency'] ?? 0.0,
        interviewReadiness:
            careerScores['interview_readiness'] ?? 0.0,
      ),
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalSessionsCompleted: totalSessions,
      currentModule: currentModule,
      lastActiveDate: lastActiveDate,
    );
  }
}
