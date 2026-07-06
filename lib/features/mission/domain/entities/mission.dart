import 'package:equatable/equatable.dart';

import 'dialogue.dart';
import 'exercise.dart';
import 'vocabulary_item.dart';
import 'yasmina_message.dart';

/// Mission outcome after completion.
enum MissionOutcome {
  /// Score ≥ 0.80 — All objectives met, strong performance.
  accomplished,

  /// Score 0.60–0.79 — Objectives met with room to improve.
  completed,

  /// Score 0.40–0.59 — Partial success, gaps present.
  advanced,

  /// Score < 0.40 — Effort made, significant gaps.
  attempted,
}

/// The type of mission.
enum MissionType {
  discovery,
  practice,
  challenge,
  simulation,
  recovery,
}

/// Skill distribution within a mission (must sum to 100).
class SkillDistribution extends Equatable {
  const SkillDistribution({
    required this.speaking,
    required this.listening,
    required this.vocabulary,
    required this.pronunciation,
    required this.reading,
    required this.writing,
  });

  final int speaking;
  final int listening;
  final int vocabulary;
  final int pronunciation;
  final int reading;
  final int writing;

  int get total =>
      speaking + listening + vocabulary + pronunciation + reading + writing;

  @override
  List<Object?> get props =>
      [speaking, listening, vocabulary, pronunciation, reading, writing];
}

/// Career readiness contribution from a mission.
class CareerContribution extends Equatable {
  const CareerContribution({
    required this.domain,
    required this.maxContributionPercent,
  });

  final String domain;
  final double maxContributionPercent;

  @override
  List<Object?> get props => [domain, maxContributionPercent];
}

/// Emotional goal for the mission experience.
class EmotionalGoal extends Equatable {
  const EmotionalGoal({
    required this.primaryEmotion,
    required this.entryFeeling,
    required this.exitFeeling,
    required this.confidenceVector,
    required this.vulnerabilityLevel,
  });

  final String primaryEmotion;
  final String entryFeeling;
  final String exitFeeling;
  final String confidenceVector;
  final String vulnerabilityLevel;

  @override
  List<Object?> get props => [
        primaryEmotion,
        entryFeeling,
        exitFeeling,
        confidenceVector,
        vulnerabilityLevel,
      ];
}

/// A complete mission definition loaded from YAML.
///
/// Contains all information needed to play a mission:
/// metadata, exercises, vocabulary, dialogue, coaching messages,
/// and assessment configuration.
class Mission extends Equatable {
  const Mission({
    required this.id,
    required this.titleEn,
    required this.titleDe,
    required this.module,
    required this.sequence,
    required this.type,
    required this.estimatedDurationMinutes,
    required this.cefrLevel,
    required this.cefrTarget,
    required this.difficulty,
    required this.skills,
    required this.careerDomains,
    required this.learningObjectiveEn,
    required this.emotionalGoal,
    required this.exercises,
    required this.vocabulary,
    required this.careerContribution,
    this.titleDarija,
    this.learningObjectiveDarija,
    this.dialogue,
    this.yasminaMessages,
    this.prerequisites = const [],
    this.tags = const [],
  });

  /// Unique mission identifier (e.g., "m01_001_d").
  final String id;

  /// Display title in English.
  final String titleEn;

  /// Display title in German.
  final String titleDe;

  /// Display title in Darija (optional).
  final String? titleDarija;

  /// Module number (1–12).
  final int module;

  /// Sequence within module (1–15).
  final int sequence;

  /// Mission type.
  final MissionType type;

  /// Expected duration in minutes.
  final int estimatedDurationMinutes;

  /// Entry CEFR level required.
  final String cefrLevel;

  /// CEFR level this contributes toward.
  final String cefrTarget;

  /// Difficulty on 1–10 scale.
  final int difficulty;

  /// Skill distribution (sums to 100).
  final SkillDistribution skills;

  /// Career domains this mission trains.
  final List<String> careerDomains;

  /// Learning objective (English).
  final String learningObjectiveEn;

  /// Learning objective (Darija, optional).
  final String? learningObjectiveDarija;

  /// Emotional goal for the mission.
  final EmotionalGoal emotionalGoal;

  /// Ordered list of exercises.
  final List<Exercise> exercises;

  /// Vocabulary items taught in this mission.
  final List<VocabularyItem> vocabulary;

  /// Dialogue script (if mission includes conversation).
  final Dialogue? dialogue;

  /// Yasmina coaching messages for various mission phases.
  final YasminaMessages? yasminaMessages;

  /// Career readiness contribution.
  final CareerContribution careerContribution;

  /// Prerequisite mission IDs.
  final List<String> prerequisites;

  /// Tags for filtering and search.
  final List<String> tags;

  /// Total number of exercises in this mission.
  int get exerciseCount => exercises.length;

  /// Total estimated time in seconds.
  int get estimatedDurationSeconds => estimatedDurationMinutes * 60;

  @override
  List<Object?> get props => [id, module, sequence, type];
}
