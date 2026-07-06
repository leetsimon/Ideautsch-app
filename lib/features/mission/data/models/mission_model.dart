import 'dart:convert';

import '../../domain/entities/mission.dart';
import '../../domain/entities/yasmina_message.dart';

/// Data model for Mission — handles SQLite ↔ Domain mapping.
///
/// The Mission entity is assembled from a main missions row plus
/// related exercises, vocabulary, and dialogue turns loaded
/// separately by the datasource.
class MissionModel {
  const MissionModel._();

  /// Convert a SQLite missions row to partial mission data.
  ///
  /// Exercises, vocabulary, and dialogue are loaded separately
  /// and injected by the datasource.
  static MissionMetadata fromMap(Map<String, dynamic> map) {
    final skills = jsonDecode(map['skills_json'] as String)
        as Map<String, dynamic>;
    final careerDomains =
        (jsonDecode(map['career_domains_json'] as String) as List<dynamic>)
            .cast<String>();
    final tags =
        (jsonDecode(map['tags_json'] as String? ?? '[]') as List<dynamic>)
            .cast<String>();
    final prerequisites =
        (jsonDecode(map['prerequisites_json'] as String? ?? '[]')
                as List<dynamic>)
            .cast<String>();

    EmotionalGoal? emotionalGoal;
    if (map['emotional_goal_json'] != null) {
      final egMap = jsonDecode(map['emotional_goal_json'] as String)
          as Map<String, dynamic>;
      emotionalGoal = EmotionalGoal(
        primaryEmotion: egMap['primary_emotion'] as String? ?? '',
        entryFeeling: egMap['entry_feeling'] as String? ?? '',
        exitFeeling: egMap['exit_feeling'] as String? ?? '',
        confidenceVector: egMap['confidence_vector'] as String? ?? 'positive',
        vulnerabilityLevel:
            egMap['vulnerability_level'] as String? ?? 'moderate',
      );
    }

    YasminaMessages? yasminaMessages;
    if (map['yasmina_json'] != null) {
      yasminaMessages = _parseYasminaMessages(
        map['yasmina_json'] as String,
      );
    }

    return MissionMetadata(
      id: map['id'] as String,
      titleEn: map['title_en'] as String,
      titleDe: map['title_de'] as String,
      titleDarija: map['title_darija'] as String?,
      module: map['module'] as int,
      sequence: map['sequence'] as int,
      type: _parseMissionType(map['type'] as String),
      estimatedDurationMinutes:
          map['estimated_duration_minutes'] as int,
      cefrLevel: map['cefr_level'] as String,
      cefrTarget: map['cefr_target'] as String,
      difficulty: map['difficulty'] as int,
      skills: SkillDistribution(
        speaking: skills['speaking'] as int? ?? 60,
        listening: skills['listening'] as int? ?? 20,
        vocabulary: skills['vocabulary'] as int? ?? 10,
        pronunciation: skills['pronunciation'] as int? ?? 5,
        reading: skills['reading'] as int? ?? 0,
        writing: skills['writing'] as int? ?? 5,
      ),
      careerDomains: careerDomains,
      careerContribution: CareerContribution(
        domain:
            map['career_contribution_domain'] as String? ?? 'phone_communication',
        maxContributionPercent:
            (map['career_contribution_max_percent'] as num?)?.toDouble() ?? 3.0,
      ),
      learningObjectiveEn: map['learning_objective_en'] as String,
      learningObjectiveDarija:
          map['learning_objective_darija'] as String?,
      emotionalGoal: emotionalGoal ??
          const EmotionalGoal(
            primaryEmotion: 'professional_confidence',
            entryFeeling: '',
            exitFeeling: '',
            confidenceVector: 'positive',
            vulnerabilityLevel: 'moderate',
          ),
      yasminaMessages: yasminaMessages,
      prerequisites: prerequisites,
      tags: tags,
    );
  }

  /// Convert mission metadata to a SQLite-compatible map.
  static Map<String, dynamic> toMap(Mission mission) {
    return {
      'id': mission.id,
      'title_en': mission.titleEn,
      'title_de': mission.titleDe,
      'title_darija': mission.titleDarija,
      'module': mission.module,
      'sequence': mission.sequence,
      'type': mission.type.name,
      'estimated_duration_minutes': mission.estimatedDurationMinutes,
      'cefr_level': mission.cefrLevel,
      'cefr_target': mission.cefrTarget,
      'difficulty': mission.difficulty,
      'skills_json': jsonEncode({
        'speaking': mission.skills.speaking,
        'listening': mission.skills.listening,
        'vocabulary': mission.skills.vocabulary,
        'pronunciation': mission.skills.pronunciation,
        'reading': mission.skills.reading,
        'writing': mission.skills.writing,
      }),
      'career_domains_json': jsonEncode(mission.careerDomains),
      'career_contribution_domain': mission.careerContribution.domain,
      'career_contribution_max_percent':
          mission.careerContribution.maxContributionPercent,
      'learning_objective_en': mission.learningObjectiveEn,
      'learning_objective_darija': mission.learningObjectiveDarija,
      'emotional_goal_json': jsonEncode({
        'primary_emotion': mission.emotionalGoal.primaryEmotion,
        'entry_feeling': mission.emotionalGoal.entryFeeling,
        'exit_feeling': mission.emotionalGoal.exitFeeling,
        'confidence_vector': mission.emotionalGoal.confidenceVector,
        'vulnerability_level': mission.emotionalGoal.vulnerabilityLevel,
      }),
      'prerequisites_json': jsonEncode(mission.prerequisites),
      'tags_json': jsonEncode(mission.tags),
      'yasmina_json': mission.yasminaMessages != null
          ? _encodeYasminaMessages(mission.yasminaMessages!)
          : null,
    };
  }

  static MissionType _parseMissionType(String value) {
    return MissionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MissionType.discovery,
    );
  }

  static YasminaMessages _parseYasminaMessages(String jsonStr) {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;

    YasminaMessage? parseMessage(
      Map<String, dynamic>? msgMap,
      YasminaMessageTrigger trigger,
    ) {
      if (msgMap == null) return null;
      return YasminaMessage(
        trigger: trigger,
        textDarija: msgMap['text_darija'] as String?,
        textEn: msgMap['text_en'] as String?,
        textDe: msgMap['text_de'] as String?,
        voiceNotes: msgMap['voice_notes'] as String?,
        triggerAfterExercise:
            msgMap['trigger_after_exercise'] as String?,
      );
    }

    return YasminaMessages(
      sessionGreeting: parseMessage(
        map['session_greeting'] as Map<String, dynamic>?,
        YasminaMessageTrigger.sessionGreeting,
      ),
      preMissionBriefing: parseMessage(
        map['pre_mission_briefing'] as Map<String, dynamic>?,
        YasminaMessageTrigger.preMissionBriefing,
      ),
      midMissionEncouragement: parseMessage(
        map['mid_mission_encouragement'] as Map<String, dynamic>?,
        YasminaMessageTrigger.midMissionEncouragement,
      ),
      postMissionDebrief: parseMessage(
        map['post_mission_debrief'] as Map<String, dynamic>?,
        YasminaMessageTrigger.postMissionDebrief,
      ),
    );
  }

  static String _encodeYasminaMessages(YasminaMessages messages) {
    Map<String, dynamic>? encodeMsg(YasminaMessage? msg) {
      if (msg == null) return null;
      return {
        'text_darija': msg.textDarija,
        'text_en': msg.textEn,
        'text_de': msg.textDe,
        'voice_notes': msg.voiceNotes,
        'trigger_after_exercise': msg.triggerAfterExercise,
      };
    }

    return jsonEncode({
      'session_greeting': encodeMsg(messages.sessionGreeting),
      'pre_mission_briefing': encodeMsg(messages.preMissionBriefing),
      'mid_mission_encouragement':
          encodeMsg(messages.midMissionEncouragement),
      'post_mission_debrief': encodeMsg(messages.postMissionDebrief),
    });
  }
}

/// Intermediate structure for mission metadata before exercises are loaded.
class MissionMetadata {
  const MissionMetadata({
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
    required this.careerContribution,
    required this.learningObjectiveEn,
    required this.emotionalGoal,
    this.titleDarija,
    this.learningObjectiveDarija,
    this.yasminaMessages,
    this.prerequisites = const [],
    this.tags = const [],
  });

  final String id;
  final String titleEn;
  final String titleDe;
  final String? titleDarija;
  final int module;
  final int sequence;
  final MissionType type;
  final int estimatedDurationMinutes;
  final String cefrLevel;
  final String cefrTarget;
  final int difficulty;
  final SkillDistribution skills;
  final List<String> careerDomains;
  final CareerContribution careerContribution;
  final String learningObjectiveEn;
  final String? learningObjectiveDarija;
  final EmotionalGoal emotionalGoal;
  final YasminaMessages? yasminaMessages;
  final List<String> prerequisites;
  final List<String> tags;
}
