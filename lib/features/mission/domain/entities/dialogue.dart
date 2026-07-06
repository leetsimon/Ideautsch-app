import 'package:equatable/equatable.dart';

/// Who is speaking in a dialogue turn.
enum Speaker {
  /// The app/narrator providing scene direction.
  system,

  /// The learner (must produce speech).
  agent,

  /// A character (learner listens).
  character,
}

/// The type of action in a dialogue turn.
enum TurnType {
  /// Stage direction or narration (displayed, not spoken by learner).
  narration,

  /// Learner must produce speech for this turn.
  production,

  /// Character speaks, learner listens.
  input,
}

/// A pattern the learner's response is matched against.
class AcceptableResponse extends Equatable {
  const AcceptableResponse({
    required this.pattern,
    required this.required_,
    required this.weight,
    this.alternatives = const [],
  });

  /// Text pattern to detect in transcription.
  final String pattern;

  /// Whether this pattern MUST be present for success.
  final bool required_;

  /// Contribution to turn score (all weights in a turn sum ~1.0).
  final double weight;

  /// Alternative patterns that also satisfy this requirement.
  final List<String> alternatives;

  @override
  List<Object?> get props => [pattern, required_, weight];
}

/// A single turn in a dialogue.
class DialogueTurn extends Equatable {
  const DialogueTurn({
    required this.turnNumber,
    required this.speaker,
    required this.type,
    this.speakerCharacterId,
    this.textDe,
    this.textDeSlow,
    this.textEn,
    this.textDarija,
    this.audioPathNative,
    this.audioPathSlow,
    this.audioPathShadow,
    this.pronunciationNotes = const [],
    this.acceptableResponses = const [],
    this.comprehensionOptions = const [],
  });

  /// Turn position in the dialogue (1-indexed).
  final int turnNumber;

  /// Who speaks this turn.
  final Speaker speaker;

  /// What happens in this turn.
  final TurnType type;

  /// Character ID for character turns (null for agent/system).
  final String? speakerCharacterId;

  /// German text of this turn.
  final String? textDe;

  /// Slow version with pauses between phrases.
  final String? textDeSlow;

  /// English translation.
  final String? textEn;

  /// Darija translation.
  final String? textDarija;

  /// Native-speed audio path.
  final String? audioPathNative;

  /// Slow-speed audio path.
  final String? audioPathSlow;

  /// Shadow-speed audio path (90%).
  final String? audioPathShadow;

  /// Pronunciation coaching notes for this turn.
  final List<PronunciationNote> pronunciationNotes;

  /// Patterns to match for production turns.
  final List<AcceptableResponse> acceptableResponses;

  /// Options for comprehension check (input turns only).
  final List<ComprehensionOptionDlg> comprehensionOptions;

  /// Whether this turn requires learner speech production.
  bool get isProductionTurn => type == TurnType.production;

  /// Whether this turn is a character speaking (learner listens).
  bool get isInputTurn => type == TurnType.input;

  @override
  List<Object?> get props => [turnNumber, speaker, type];
}

/// A pronunciation note attached to a specific segment.
class PronunciationNote extends Equatable {
  const PronunciationNote({
    required this.segment,
    required this.note,
  });

  final String segment;
  final String note;

  @override
  List<Object?> get props => [segment, note];
}

/// Comprehension option within a dialogue turn.
class ComprehensionOptionDlg extends Equatable {
  const ComprehensionOptionDlg({
    required this.textEn,
    required this.isCorrect,
    this.textDarija,
  });

  final String textEn;
  final String? textDarija;
  final bool isCorrect;

  @override
  List<Object?> get props => [textEn, isCorrect];
}

/// A complete dialogue script for a mission.
class Dialogue extends Equatable {
  const Dialogue({
    required this.id,
    required this.context,
    required this.turns,
    required this.estimatedDurationSeconds,
  });

  /// Unique dialogue identifier.
  final String id;

  /// Brief description of the dialogue scenario.
  final String context;

  /// Ordered list of dialogue turns.
  final List<DialogueTurn> turns;

  /// Expected total duration in seconds.
  final int estimatedDurationSeconds;

  /// Number of turns where the learner speaks.
  int get productionTurnCount =>
      turns.where((t) => t.isProductionTurn).length;

  /// Total turn count.
  int get totalTurns => turns.length;

  @override
  List<Object?> get props => [id, turns.length];
}
