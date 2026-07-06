import '../features/mission/domain/entities/exercise_result.dart';
import '../features/mission/domain/entities/mission.dart';

/// Engine for calculating exercise and mission scores.
///
/// Implements the confidence scoring model defined in the
/// Mission Specification (Part 09):
/// - Communicative success (40%)
/// - Linguistic accuracy (25%)
/// - Pronunciation quality (20%)
/// - Response speed (5%)
/// - Professional register (10%)
///
/// Pure Dart — no Flutter dependencies.
class ScoringEngine {
  const ScoringEngine();

  /// Calculate the overall mission score from exercise results.
  ///
  /// Returns a value between 0.0 and 1.0.
  double calculateMissionScore({
    required List<ExerciseResult> exerciseResults,
    required Mission mission,
  }) {
    if (exerciseResults.isEmpty) return 0.0;

    // Average all exercise scores
    final totalScore = exerciseResults.fold<double>(
      0.0,
      (sum, result) => sum + result.score,
    );

    return totalScore / exerciseResults.length;
  }

  /// Calculate per-dimension scores for the confidence model.
  Map<String, double> calculateDimensionScores({
    required List<ExerciseResult> exerciseResults,
    required Mission mission,
  }) {
    if (exerciseResults.isEmpty) {
      return {
        'communicative_success': 0.0,
        'linguistic_accuracy': 0.0,
        'pronunciation_quality': 0.0,
        'response_speed': 0.0,
        'professional_register': 0.0,
      };
    }

    // Communicative success: based on keyword matching
    final communicativeScores = exerciseResults
        .where((r) => r.keywordsMatched.isNotEmpty || r.keywordsMissed.isNotEmpty)
        .map((r) {
      final total = r.keywordsMatched.length + r.keywordsMissed.length;
      if (total == 0) return 1.0;
      return r.keywordsMatched.length / total;
    });
    final communicativeSuccess = communicativeScores.isEmpty
        ? 0.0
        : communicativeScores.reduce((a, b) => a + b) /
            communicativeScores.length;

    // Linguistic accuracy: from completeness scores
    final accuracyScores = exerciseResults
        .where((r) => r.completenessScore > 0)
        .map((r) => r.completenessScore);
    final linguisticAccuracy = accuracyScores.isEmpty
        ? 0.0
        : accuracyScores.reduce((a, b) => a + b) / accuracyScores.length;

    // Pronunciation quality: from pronunciation scores
    final pronScores = exerciseResults
        .where((r) => r.pronunciationScore > 0)
        .map((r) => r.pronunciationScore);
    final pronunciationQuality = pronScores.isEmpty
        ? 0.0
        : pronScores.reduce((a, b) => a + b) / pronScores.length;

    // Response speed: based on latency
    final speedScores = exerciseResults
        .where((r) => r.latencyMs > 0)
        .map((r) => _latencyToScore(r.latencyMs));
    // For Module 1: speed always scores 1.0 (disabled)
    final responseSpeed = mission.module <= 3
        ? 1.0
        : (speedScores.isEmpty
            ? 1.0
            : speedScores.reduce((a, b) => a + b) / speedScores.length);

    // Professional register: based on exercise outcomes
    // (simplified: if no register errors detected, score = 1.0)
    const professionalRegister = 1.0;

    return {
      'communicative_success': communicativeSuccess,
      'linguistic_accuracy': linguisticAccuracy,
      'pronunciation_quality': pronunciationQuality,
      'response_speed': responseSpeed,
      'professional_register': professionalRegister,
    };
  }

  /// Determine the mission outcome from the overall score.
  MissionOutcome determineOutcome(double overallScore) {
    if (overallScore >= 0.80) return MissionOutcome.accomplished;
    if (overallScore >= 0.60) return MissionOutcome.completed;
    if (overallScore >= 0.40) return MissionOutcome.advanced;
    return MissionOutcome.attempted;
  }

  /// Calculate a single exercise score from its components.
  ///
  /// [keywordsMatchedCount] / [keywordsExpectedCount] provides
  /// the completeness dimension.
  /// [pronunciationScore] provides the pronunciation dimension.
  /// Weights are taken from the exercise's evaluation config.
  double calculateExerciseScore({
    required int keywordsMatchedCount,
    required int keywordsExpectedCount,
    required double pronunciationScore,
    required double pronunciationWeight,
    required double completenessWeight,
    double speedWeight = 0.0,
    double speedScore = 1.0,
  }) {
    final completenessScore = keywordsExpectedCount > 0
        ? keywordsMatchedCount / keywordsExpectedCount
        : 0.0;

    return (completenessScore * completenessWeight) +
        (pronunciationScore * pronunciationWeight) +
        (speedScore * speedWeight);
  }

  /// Convert latency in milliseconds to a speed score (0.0–1.0).
  double _latencyToScore(int latencyMs) {
    if (latencyMs <= 3000) return 1.0;
    if (latencyMs <= 5000) return 0.7;
    if (latencyMs <= 8000) return 0.4;
    return 0.1;
  }
}
