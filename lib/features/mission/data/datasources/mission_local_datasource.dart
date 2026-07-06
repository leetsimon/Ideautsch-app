import 'dart:convert';

import '../../../../core/constants/db_constants.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/dialogue.dart';
import '../../domain/entities/vocabulary_item.dart';
import '../models/exercise_model.dart';
import '../models/mission_model.dart';
import '../../domain/entities/exercise.dart';

/// Local SQLite datasource for mission content data.
///
/// Queries the content database (read-only) for mission
/// metadata, exercises, vocabulary, and dialogue turns.
class MissionLocalDatasource {
  MissionLocalDatasource(this._provider);

  final DatabaseProvider _provider;

  /// Load full mission metadata by ID.
  Future<MissionMetadata> getMissionMetadata(String missionId) async {
    final results = await _provider.contentDb.query(
      DbConstants.tableMissions,
      where: 'id = ?',
      whereArgs: [missionId],
    );

    if (results.isEmpty) {
      throw ContentNotFoundException(
        message: 'Mission "$missionId" not found in content database.',
      );
    }

    return MissionModel.fromMap(results.first);
  }

  /// Load all exercises for a mission, ordered by sequence.
  Future<List<Exercise>> getExercisesForMission(String missionId) async {
    final results = await _provider.contentDb.query(
      DbConstants.tableExercises,
      where: 'mission_id = ?',
      whereArgs: [missionId],
      orderBy: 'order_index ASC',
    );

    return results.map(ExerciseModel.fromMap).toList();
  }

  /// Load all vocabulary items for a mission.
  Future<List<VocabularyItem>> getVocabularyForMission(
    String missionId,
  ) async {
    final results = await _provider.contentDb.query(
      DbConstants.tableVocabulary,
      where: 'mission_id = ?',
      whereArgs: [missionId],
    );

    return results.map(_mapVocabulary).toList();
  }

  /// Load dialogue turns for a mission's dialogue.
  Future<Dialogue?> getDialogueForMission(String missionId) async {
    final results = await _provider.contentDb.query(
      DbConstants.tableConversationTurns,
      where: 'mission_id = ?',
      whereArgs: [missionId],
      orderBy: 'turn_number ASC',
    );

    if (results.isEmpty) return null;

    final dialogueId = results.first['dialogue_id'] as String;
    final turns = results.map(_mapDialogueTurn).toList();

    return Dialogue(
      id: dialogueId,
      context: 'Loaded from mission $missionId',
      turns: turns,
      estimatedDurationSeconds: turns.length * 15,
    );
  }

  /// Load all missions (metadata only, for selection screen).
  Future<List<MissionMetadata>> getAllMissions() async {
    final results = await _provider.contentDb.query(
      DbConstants.tableMissions,
      orderBy: 'module ASC, sequence ASC',
    );

    return results.map(MissionModel.fromMap).toList();
  }

  /// Load missions for a specific module.
  Future<List<MissionMetadata>> getMissionsByModule(int module) async {
    final results = await _provider.contentDb.query(
      DbConstants.tableMissions,
      where: 'module = ?',
      whereArgs: [module],
      orderBy: 'sequence ASC',
    );

    return results.map(MissionModel.fromMap).toList();
  }

  VocabularyItem _mapVocabulary(Map<String, dynamic> map) {
    final contextVariations =
        (jsonDecode(map['context_variations_json'] as String? ?? '[]')
                as List<dynamic>)
            .cast<String>();

    return VocabularyItem(
      id: map['id'] as String,
      chunkPhrase: map['chunk_phrase'] as String,
      functionalMeaning: map['functional_meaning'] as String,
      literalMeaning: map['literal_meaning'] as String?,
      translationEn: map['translation_en'] as String,
      translationDarija: map['translation_darija'] as String?,
      translationFr: map['translation_fr'] as String?,
      ipa: map['ipa'] as String?,
      audioNative: map['audio_native'] as String,
      audioSlow: map['audio_slow'] as String?,
      exampleDe: map['example_de'] as String?,
      exampleEn: map['example_en'] as String?,
      exampleAudio: map['example_audio'] as String?,
      register: map['register'] as String,
      domain: map['domain'] as String,
      cluster: map['cluster'] as String,
      srsInitialIntervalHours:
          map['srs_initial_interval_hours'] as int? ?? 12,
      srsInitialEaseFactor:
          (map['srs_initial_ease_factor'] as num?)?.toDouble() ?? 2.5,
      contextVariations: contextVariations,
    );
  }

  DialogueTurn _mapDialogueTurn(Map<String, dynamic> map) {
    final pronNotes =
        (jsonDecode(map['pronunciation_notes_json'] as String? ?? '[]')
                as List<dynamic>)
            .map((n) {
      final noteMap = n as Map<String, dynamic>;
      return PronunciationNote(
        segment: noteMap['segment'] as String? ?? '',
        note: noteMap['note'] as String? ?? '',
      );
    }).toList();

    final acceptableResponses =
        (jsonDecode(map['acceptable_responses_json'] as String? ?? '[]')
                as List<dynamic>)
            .map((r) {
      final respMap = r as Map<String, dynamic>;
      return AcceptableResponse(
        pattern: respMap['pattern'] as String? ?? '',
        required_: respMap['required'] as bool? ?? false,
        weight: (respMap['weight'] as num?)?.toDouble() ?? 0.0,
        alternatives: ((respMap['alternatives'] as List<dynamic>?) ?? [])
            .cast<String>(),
      );
    }).toList();

    final comprehensionOptions =
        (jsonDecode(map['comprehension_options_json'] as String? ?? '[]')
                as List<dynamic>)
            .map((o) {
      final optMap = o as Map<String, dynamic>;
      return ComprehensionOptionDlg(
        textEn: optMap['text_en'] as String? ?? '',
        textDarija: optMap['text_darija'] as String?,
        isCorrect: optMap['correct'] as bool? ?? false,
      );
    }).toList();

    return DialogueTurn(
      turnNumber: map['turn_number'] as int,
      speaker: _parseSpeaker(map['speaker'] as String),
      type: _parseTurnType(map['type'] as String),
      speakerCharacterId: map['speaker_character_id'] as String?,
      textDe: map['text_de'] as String?,
      textDeSlow: map['text_de_slow'] as String?,
      textEn: map['text_en'] as String?,
      textDarija: map['text_darija'] as String?,
      audioPathNative: map['audio_path_native'] as String?,
      audioPathSlow: map['audio_path_slow'] as String?,
      audioPathShadow: map['audio_path_shadow'] as String?,
      pronunciationNotes: pronNotes,
      acceptableResponses: acceptableResponses,
      comprehensionOptions: comprehensionOptions,
    );
  }

  Speaker _parseSpeaker(String value) {
    if (value == 'agent') return Speaker.agent;
    if (value == 'system') return Speaker.system;
    return Speaker.character;
  }

  TurnType _parseTurnType(String value) {
    if (value == 'production') return TurnType.production;
    if (value == 'narration') return TurnType.narration;
    return TurnType.input;
  }
}
