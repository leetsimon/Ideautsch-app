import 'package:equatable/equatable.dart';

import '../../domain/entities/exercise_result.dart';

/// Events that drive the [MissionBloc] state machine.
///
/// These events represent all user actions and system triggers
/// that occur during mission playback.
sealed class MissionEvent extends Equatable {
  const MissionEvent();

  @override
  List<Object?> get props => [];
}

/// Load a mission by its ID for playback.
final class LoadMissionEvent extends MissionEvent {
  const LoadMissionEvent({required this.missionId});

  final String missionId;

  @override
  List<Object?> get props => [missionId];
}

/// Start the mission (transition from briefing to first exercise).
final class StartMissionEvent extends MissionEvent {
  const StartMissionEvent();
}

/// Play the audio model for the current exercise.
final class PlayAudioEvent extends MissionEvent {
  const PlayAudioEvent({this.audioPath, this.speed = 1.0});

  final String? audioPath;
  final double speed;

  @override
  List<Object?> get props => [audioPath, speed];
}

/// Begin recording the learner's speech.
final class StartRecordingEvent extends MissionEvent {
  const StartRecordingEvent();
}

/// Stop recording and evaluate the learner's speech.
final class StopRecordingEvent extends MissionEvent {
  const StopRecordingEvent();
}

/// Submit a completed exercise result and advance.
final class SubmitExerciseEvent extends MissionEvent {
  const SubmitExerciseEvent({required this.result});

  final ExerciseResult result;

  @override
  List<Object?> get props => [result];
}

/// Select an answer for a comprehension exercise.
final class SelectAnswerEvent extends MissionEvent {
  const SelectAnswerEvent({required this.optionIndex});

  final int optionIndex;

  @override
  List<Object?> get props => [optionIndex];
}

/// Submit typed text (for dictation exercises).
final class SubmitTextEvent extends MissionEvent {
  const SubmitTextEvent({required this.text});

  final String text;

  @override
  List<Object?> get props => [text];
}

/// Advance to the next exercise after viewing feedback.
final class NextExerciseEvent extends MissionEvent {
  const NextExerciseEvent();
}

/// Request a hint for the current exercise.
final class RequestHintEvent extends MissionEvent {
  const RequestHintEvent();
}

/// Retry the current exercise (after feedback).
final class RetryExerciseEvent extends MissionEvent {
  const RetryExerciseEvent();
}

/// Complete the mission (all exercises done).
final class CompleteMissionEvent extends MissionEvent {
  const CompleteMissionEvent();
}

/// Dismiss the Yasmina coaching message.
final class DismissYasminaEvent extends MissionEvent {
  const DismissYasminaEvent();
}

/// Pause the mission (user navigated away or backgrounded).
final class PauseMissionEvent extends MissionEvent {
  const PauseMissionEvent();
}

/// Resume a paused mission.
final class ResumeMissionEvent extends MissionEvent {
  const ResumeMissionEvent();
}
