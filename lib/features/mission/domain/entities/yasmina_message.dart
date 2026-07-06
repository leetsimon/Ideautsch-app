import 'package:equatable/equatable.dart';

/// When a Yasmina message should be displayed.
enum YasminaMessageTrigger {
  sessionGreeting,
  preMissionBriefing,
  midMissionEncouragement,
  postMissionDebrief,
}

/// A single coaching message from Yasmina.
class YasminaMessage extends Equatable {
  const YasminaMessage({
    required this.trigger,
    this.textDarija,
    this.textEn,
    this.textDe,
    this.voiceNotes,
    this.triggerAfterExercise,
  });

  /// When this message appears.
  final YasminaMessageTrigger trigger;

  /// Message in Darija (primary for early modules).
  final String? textDarija;

  /// Message in English.
  final String? textEn;

  /// Message in German (for later modules).
  final String? textDe;

  /// Direction notes for voice/tone.
  final String? voiceNotes;

  /// Exercise ID that triggers mid-mission messages.
  final String? triggerAfterExercise;

  @override
  List<Object?> get props => [trigger, textEn];
}

/// Collection of all Yasmina messages for a mission.
class YasminaMessages extends Equatable {
  const YasminaMessages({
    this.sessionGreeting,
    this.preMissionBriefing,
    this.midMissionEncouragement,
    this.postMissionDebrief,
  });

  final YasminaMessage? sessionGreeting;
  final YasminaMessage? preMissionBriefing;
  final YasminaMessage? midMissionEncouragement;
  final YasminaMessage? postMissionDebrief;

  @override
  List<Object?> get props => [
        sessionGreeting,
        preMissionBriefing,
        midMissionEncouragement,
        postMissionDebrief,
      ];
}
