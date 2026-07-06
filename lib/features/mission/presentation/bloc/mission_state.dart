import 'package:equatable/equatable.dart';

import '../../../../engines/mission_state_machine.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_result.dart';
import '../../domain/entities/mission.dart';
import '../../domain/entities/mission_result.dart';

/// The phase of the current exercise within the player flow.
enum ExercisePlayPhase {
  /// Exercise prompt is being presented.
  presenting,

  /// Yasmina coaching message is being shown.
  showingYasmina,

  /// Audio model is playing for the learner to listen.
  playingAudio,

  /// Learner is actively recording their speech.
  recording,

  /// System is evaluating the learner's response.
  evaluating,

  /// Feedback is being displayed.
  showingFeedback,
}

/// States emitted by [MissionBloc].
sealed class MissionState extends Equatable {
  const MissionState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any mission is loaded.
final class MissionInitial extends MissionState {
  const MissionInitial();
}

/// Mission data is being loaded from the database.
final class MissionLoading extends MissionState {
  const MissionLoading();
}

/// Mission is loaded and the briefing screen is shown.
///
/// The learner sees the mission title, scenario description,
/// Yasmina's greeting, and a "Begin" button.
final class MissionBriefing extends MissionState {
  const MissionBriefing({
    required this.mission,
    required this.yasminaGreeting,
    this.resumeExerciseIndex,
  });

  /// The loaded mission data.
  final Mission mission;

  /// Yasmina's session greeting text.
  final String yasminaGreeting;

  /// If non-null, learner can resume from this exercise.
  final int? resumeExerciseIndex;

  @override
  List<Object?> get props => [mission.id, resumeExerciseIndex];
}

/// Mission is actively being played (exercise flow).
///
/// This is the primary state during mission execution.
/// Contains all information needed to render the current exercise.
final class MissionInProgress extends MissionState {
  const MissionInProgress({
    required this.mission,
    required this.currentExercise,
    required this.exerciseIndex,
    required this.totalExercises,
    required this.phase,
    required this.supportLevel,
    required this.currentScaffolding,
    this.lastResult,
    this.hintText,
    this.isRecording = false,
    this.recordingDuration = Duration.zero,
    this.currentAttempt = 1,
    this.yasminaMessage,
  });

  final Mission mission;
  final Exercise currentExercise;
  final int exerciseIndex;
  final int totalExercises;
  final ExercisePlayPhase phase;
  final SupportLevel supportLevel;
  final ScaffoldLevel currentScaffolding;
  final ExerciseResult? lastResult;
  final String? hintText;
  final bool isRecording;
  final Duration recordingDuration;
  final int currentAttempt;
  final String? yasminaMessage;

  /// Progress through the mission (0.0–1.0).
  double get progress =>
      totalExercises > 0 ? (exerciseIndex + 1) / totalExercises : 0.0;

  /// Whether the learner can retry this exercise.
  bool get canRetry => currentAttempt < currentExercise.maxAttempts;

  /// Create a copy with updated fields.
  MissionInProgress copyWith({
    ExercisePlayPhase? phase,
    ExerciseResult? lastResult,
    String? hintText,
    bool? isRecording,
    Duration? recordingDuration,
    int? currentAttempt,
    String? yasminaMessage,
    bool clearYasmina = false,
    bool clearHint = false,
    bool clearResult = false,
  }) {
    return MissionInProgress(
      mission: mission,
      currentExercise: currentExercise,
      exerciseIndex: exerciseIndex,
      totalExercises: totalExercises,
      phase: phase ?? this.phase,
      supportLevel: supportLevel,
      currentScaffolding: currentScaffolding,
      lastResult: clearResult ? null : (lastResult ?? this.lastResult),
      hintText: clearHint ? null : (hintText ?? this.hintText),
      isRecording: isRecording ?? this.isRecording,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      currentAttempt: currentAttempt ?? this.currentAttempt,
      yasminaMessage: clearYasmina
          ? null
          : (yasminaMessage ?? this.yasminaMessage),
    );
  }

  @override
  List<Object?> get props => [
        mission.id,
        exerciseIndex,
        phase,
        isRecording,
        currentAttempt,
        lastResult,
      ];
}

/// Mission is complete — showing the summary screen.
final class MissionCompleted extends MissionState {
  const MissionCompleted({
    required this.mission,
    required this.result,
    required this.yasminaDebrief,
  });

  final Mission mission;
  final MissionResult result;
  final String yasminaDebrief;

  @override
  List<Object?> get props => [mission.id, result.outcome];
}

/// An error occurred during mission loading or playback.
final class MissionError extends MissionState {
  const MissionError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
