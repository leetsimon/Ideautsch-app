import 'package:equatable/equatable.dart';

/// The outcome level of a single exercise attempt.
enum ExerciseOutcome {
  /// Scored well — clean production, keywords matched.
  success,

  /// Partially correct — communicated but imperfect.
  partial,

  /// Needs another attempt — significant gaps.
  retry,

  /// Skipped or not attempted.
  skipped,
}

/// Result of a single exercise attempt by the learner.
///
/// Captures both the quantitative score and qualitative
/// outcome for use by the scoring engine and SRS system.
class ExerciseResult extends Equatable {
  const ExerciseResult({
    required this.exerciseId,
    required this.outcome,
    required this.score,
    required this.attemptNumber,
    required this.timeSpentSeconds,
    this.transcription,
    this.keywordsMatched = const [],
    this.keywordsMissed = const [],
    this.pronunciationScore = 0.0,
    this.completenessScore = 0.0,
    this.latencyMs = 0,
    this.recordingPath,
    this.selectedOptionIndex,
    this.typedText,
  });

  /// ID of the exercise this result belongs to.
  final String exerciseId;

  /// Qualitative outcome.
  final ExerciseOutcome outcome;

  /// Quantitative score (0.0–1.0).
  final double score;

  /// Which attempt this was (1-indexed).
  final int attemptNumber;

  /// Time spent on this attempt in seconds.
  final int timeSpentSeconds;

  /// Transcription of learner's speech (from Vosk).
  final String? transcription;

  /// Keywords that were successfully matched.
  final List<String> keywordsMatched;

  /// Required keywords that were NOT matched.
  final List<String> keywordsMissed;

  /// Pronunciation quality score (0.0–1.0).
  final double pronunciationScore;

  /// Completeness score (0.0–1.0).
  final double completenessScore;

  /// Response latency in milliseconds (prompt to speech onset).
  final int latencyMs;

  /// Path to saved audio recording (if any).
  final String? recordingPath;

  /// Selected option index for comprehension exercises.
  final int? selectedOptionIndex;

  /// Typed text for dictation exercises.
  final String? typedText;

  /// Whether this attempt counts as passing.
  bool get isPassing => outcome == ExerciseOutcome.success ||
      outcome == ExerciseOutcome.partial;

  @override
  List<Object?> get props => [exerciseId, outcome, score, attemptNumber];
}
