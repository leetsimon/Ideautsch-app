import 'package:equatable/equatable.dart';

import 'exercise_result.dart';
import 'mission.dart';

/// Aggregated result of a completed mission.
///
/// Contains the overall outcome, individual exercise results,
/// dimension scores, and career readiness contribution.
class MissionResult extends Equatable {
  const MissionResult({
    required this.missionId,
    required this.outcome,
    required this.overallScore,
    required this.exerciseResults,
    required this.dimensionScores,
    required this.totalSpeakingTimeSeconds,
    required this.totalTimeSeconds,
    required this.careerReadinessContribution,
    required this.completedAt,
    this.newVocabularyLearned = 0,
  });

  /// ID of the completed mission.
  final String missionId;

  /// Overall mission outcome (accomplished/completed/advanced/attempted).
  final MissionOutcome outcome;

  /// Overall score (0.0–1.0).
  final double overallScore;

  /// Individual exercise results.
  final List<ExerciseResult> exerciseResults;

  /// Scores per confidence dimension.
  final Map<String, double> dimensionScores;

  /// Total time the learner spent speaking (seconds).
  final int totalSpeakingTimeSeconds;

  /// Total mission time (seconds).
  final int totalTimeSeconds;

  /// Career readiness percentage contributed by this mission.
  final double careerReadinessContribution;

  /// Number of new vocabulary items entering SRS.
  final int newVocabularyLearned;

  /// When the mission was completed.
  final DateTime completedAt;

  /// How many exercises were completed successfully.
  int get successfulExercises =>
      exerciseResults.where((r) => r.isPassing).length;

  /// Total exercises attempted.
  int get totalExercisesAttempted => exerciseResults.length;

  @override
  List<Object?> get props => [missionId, outcome, overallScore];
}
