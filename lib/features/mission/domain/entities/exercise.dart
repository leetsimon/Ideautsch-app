import 'package:equatable/equatable.dart';

/// The type of exercise presented to the learner.
enum ExerciseType {
  /// Immediate repetition after hearing a model.
  shadow,

  /// Produce from memory given a situational prompt.
  repeat,

  /// Listen to audio and answer a comprehension question.
  listenComprehend,

  /// Introduction of new vocabulary (hear → shadow → produce).
  vocabularyPresent,

  /// Multi-turn dialogue role-play.
  conversation,

  /// Production within a time constraint.
  timePressure,

  /// Hear a sentence, pause, reproduce from memory.
  reconstruct,

  /// Produce the correct register version.
  parallelTracks,

  /// Hear a bad response and produce improved version.
  rescue,

  /// Hear numbers/addresses and type them.
  dictation,
}

/// The session phase an exercise belongs to.
enum ExercisePhase {
  /// Warm-up with known material.
  ignite,

  /// Introduction of new material.
  equip,

  /// Full scenario application.
  challenge,

  /// Cool-down and consolidation.
  land,
}

/// The evaluation method used to score the exercise.
enum EvaluationMode {
  /// Compare spoken output to expected keywords + pronunciation.
  pronunciationMatch,

  /// Multiple choice or keyword detection for listening.
  comprehensionCheck,

  /// Aggregate scoring across dialogue turns.
  dialogueCompletion,

  /// Check for formal/informal register markers.
  registerMatch,

  /// Character-by-character text comparison.
  textMatch,

  /// Check that bad markers are absent and good markers present.
  errorDetection,
}

/// Configuration for how an exercise is evaluated.
class EvaluationConfig extends Equatable {
  const EvaluationConfig({
    this.minimumScore = 0.45,
    this.keywordsRequired = const [],
    this.keywordsOptional = const [],
    this.pronunciationWeight = 0.6,
    this.completenessWeight = 0.4,
    this.speedWeight = 0.0,
    this.comprehensionOptions = const [],
    this.expectedText,
    this.dialogueId,
    this.weightPerTurn = const {},
  });

  /// Minimum score to count as successful (0.0–1.0).
  final double minimumScore;

  /// Keywords that MUST be present for full score.
  final List<String> keywordsRequired;

  /// Keywords that contribute to score but aren't mandatory.
  final List<String> keywordsOptional;

  /// Weight of pronunciation quality in final score.
  final double pronunciationWeight;

  /// Weight of completeness (all keywords present) in final score.
  final double completenessWeight;

  /// Weight of response speed (for time_pressure exercises).
  final double speedWeight;

  /// Options for comprehension check exercises.
  final List<ComprehensionOption> comprehensionOptions;

  /// Expected text for dictation exercises.
  final String? expectedText;

  /// Reference to dialogue for conversation exercises.
  final String? dialogueId;

  /// Weight distribution per turn for dialogue scoring.
  final Map<int, double> weightPerTurn;

  @override
  List<Object?> get props => [
        minimumScore,
        keywordsRequired,
        keywordsOptional,
        pronunciationWeight,
        completenessWeight,
        speedWeight,
        comprehensionOptions,
        expectedText,
        dialogueId,
        weightPerTurn,
      ];
}

/// A single option in a comprehension check exercise.
class ComprehensionOption extends Equatable {
  const ComprehensionOption({
    required this.textEn,
    required this.isCorrect,
    this.textDarija,
  });

  final String textEn;
  final String? textDarija;
  final bool isCorrect;

  @override
  List<Object?> get props => [textEn, isCorrect, textDarija];
}

/// Three-level scaffolding for adaptive difficulty.
class Scaffolding extends Equatable {
  const Scaffolding({
    required this.supportHigh,
    required this.supportStandard,
    required this.supportMinimal,
  });

  final ScaffoldLevel supportHigh;
  final ScaffoldLevel supportStandard;
  final ScaffoldLevel supportMinimal;

  @override
  List<Object?> get props => [supportHigh, supportStandard, supportMinimal];
}

/// A single scaffolding level configuration.
class ScaffoldLevel extends Equatable {
  const ScaffoldLevel({
    this.textVisible = false,
    this.audioModelFirst = false,
    this.hintAvailable = false,
    this.hintText,
    this.wordBank,
    this.firstWordsVisible = false,
    this.firstWords = const [],
  });

  final bool textVisible;
  final bool audioModelFirst;
  final bool hintAvailable;
  final String? hintText;
  final List<String>? wordBank;
  final bool firstWordsVisible;
  final List<String> firstWords;

  @override
  List<Object?> get props => [
        textVisible,
        audioModelFirst,
        hintAvailable,
        hintText,
        wordBank,
        firstWordsVisible,
        firstWords,
      ];
}

/// Feedback messages displayed after exercise completion.
class ExerciseFeedback extends Equatable {
  const ExerciseFeedback({
    required this.onSuccess,
    required this.onPartial,
    required this.onRetry,
    this.onSuccessDarija,
  });

  final String onSuccess;
  final String onPartial;
  final String onRetry;
  final String? onSuccessDarija;

  @override
  List<Object?> get props => [onSuccess, onPartial, onRetry, onSuccessDarija];
}

/// A single exercise within a mission.
///
/// Exercises are the atomic units of learning. Each exercise
/// has a type, belongs to a phase, and carries its own evaluation
/// configuration and scaffolding.
class Exercise extends Equatable {
  const Exercise({
    required this.id,
    required this.type,
    required this.order,
    required this.phase,
    required this.promptTextEn,
    required this.evaluationMode,
    required this.evaluationConfig,
    required this.scaffolding,
    required this.feedback,
    required this.maxAttempts,
    required this.estimatedDurationSeconds,
    this.promptTextDarija,
    this.targetTextDe,
    this.targetAudioNative,
    this.targetAudioSlow,
    this.timeLimitSeconds,
    this.vocabularyIds = const [],
    this.srsTrigger = false,
    this.dialogueId,
  });

  final String id;
  final ExerciseType type;
  final int order;
  final ExercisePhase phase;
  final String promptTextEn;
  final String? promptTextDarija;
  final String? targetTextDe;
  final String? targetAudioNative;
  final String? targetAudioSlow;
  final EvaluationMode evaluationMode;
  final EvaluationConfig evaluationConfig;
  final Scaffolding scaffolding;
  final ExerciseFeedback feedback;
  final int maxAttempts;
  final int? timeLimitSeconds;
  final int estimatedDurationSeconds;
  final List<String> vocabularyIds;
  final bool srsTrigger;
  final String? dialogueId;

  @override
  List<Object?> get props => [id, type, order, phase];
}
