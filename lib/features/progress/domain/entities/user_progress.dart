import 'package:equatable/equatable.dart';

/// Overall user progress across the entire application.
///
/// This is the aggregate view of the learner's journey,
/// including career readiness, vocabulary mastery, and
/// learning statistics.
class UserProgress extends Equatable {
  const UserProgress({
    required this.missionsCompleted,
    required this.totalSpeakingTimeSeconds,
    required this.vocabularyLearned,
    required this.vocabularyMastered,
    required this.careerReadiness,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalSessionsCompleted,
    required this.currentModule,
    required this.lastActiveDate,
  });

  /// Total missions completed with any outcome.
  final int missionsCompleted;

  /// Cumulative speaking time in seconds.
  final int totalSpeakingTimeSeconds;

  /// Vocabulary items that have entered SRS.
  final int vocabularyLearned;

  /// Vocabulary items at long-term interval (>21 days).
  final int vocabularyMastered;

  /// Career readiness scores per domain.
  final CareerReadiness careerReadiness;

  /// Current consecutive practice days.
  final int currentStreak;

  /// All-time longest streak.
  final int longestStreak;

  /// Total learning sessions completed.
  final int totalSessionsCompleted;

  /// Highest module with at least one completed mission.
  final int currentModule;

  /// Last date the learner practiced.
  final DateTime lastActiveDate;

  /// Total speaking time formatted as hours:minutes.
  String get speakingTimeFormatted {
    final hours = totalSpeakingTimeSeconds ~/ 3600;
    final minutes = (totalSpeakingTimeSeconds % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }

  /// Overall career readiness percentage (0–100).
  double get overallCareerReadinessPercent =>
      careerReadiness.overallPercent;

  @override
  List<Object?> get props => [
        missionsCompleted,
        totalSpeakingTimeSeconds,
        vocabularyLearned,
        currentModule,
      ];
}

/// Career readiness scores broken down by domain.
class CareerReadiness extends Equatable {
  const CareerReadiness({
    this.phoneCommunication = 0.0,
    this.customerHandling = 0.0,
    this.professionalLanguage = 0.0,
    this.speakingFluency = 0.0,
    this.interviewReadiness = 0.0,
  });

  /// Phone communication skills (0–100%).
  final double phoneCommunication;

  /// Customer handling skills (0–100%).
  final double customerHandling;

  /// Professional language quality (0–100%).
  final double professionalLanguage;

  /// Speaking fluency metrics (0–100%).
  final double speakingFluency;

  /// Interview preparedness (0–100%).
  final double interviewReadiness;

  /// Weighted overall percentage.
  double get overallPercent =>
      (phoneCommunication * 0.25 +
          customerHandling * 0.25 +
          professionalLanguage * 0.20 +
          speakingFluency * 0.15 +
          interviewReadiness * 0.15);

  /// Create a new instance with one domain updated.
  CareerReadiness copyWithDomain(String domain, double value) {
    switch (domain) {
      case 'phone_communication':
        return CareerReadiness(
          phoneCommunication: value,
          customerHandling: customerHandling,
          professionalLanguage: professionalLanguage,
          speakingFluency: speakingFluency,
          interviewReadiness: interviewReadiness,
        );
      case 'customer_handling':
        return CareerReadiness(
          phoneCommunication: phoneCommunication,
          customerHandling: value,
          professionalLanguage: professionalLanguage,
          speakingFluency: speakingFluency,
          interviewReadiness: interviewReadiness,
        );
      case 'professional_language':
        return CareerReadiness(
          phoneCommunication: phoneCommunication,
          customerHandling: customerHandling,
          professionalLanguage: value,
          speakingFluency: speakingFluency,
          interviewReadiness: interviewReadiness,
        );
      case 'speaking_fluency':
        return CareerReadiness(
          phoneCommunication: phoneCommunication,
          customerHandling: customerHandling,
          professionalLanguage: professionalLanguage,
          speakingFluency: value,
          interviewReadiness: interviewReadiness,
        );
      case 'interview_readiness':
        return CareerReadiness(
          phoneCommunication: phoneCommunication,
          customerHandling: customerHandling,
          professionalLanguage: professionalLanguage,
          speakingFluency: speakingFluency,
          interviewReadiness: value,
        );
      default:
        return this;
    }
  }

  @override
  List<Object?> get props => [
        phoneCommunication,
        customerHandling,
        professionalLanguage,
        speakingFluency,
        interviewReadiness,
      ];
}
