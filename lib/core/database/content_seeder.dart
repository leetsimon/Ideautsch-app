import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../constants/db_constants.dart';
import 'database_provider.dart';

/// Seeds the content database with mission data.
///
/// In production, this class reads pre-processed mission data
/// (converted from YAML to JSON at build time) and inserts it
/// into the content SQLite database.
///
/// For development, it accepts a map structure matching the
/// mission YAML schema and inserts all sections.
class ContentSeeder {
  ContentSeeder(this._provider);

  final DatabaseProvider _provider;

  /// Seed a complete mission into the content database.
  ///
  /// [missionData] is a Map matching the mission YAML structure
  /// (pre-parsed from YAML → Map during build pipeline or at
  /// development time).
  Future<void> seedMission(Map<String, dynamic> missionData) async {
    final db = _provider.contentDb;

    await db.transaction((txn) async {
      // 1. Insert mission metadata
      await _insertMission(txn, missionData);

      // 2. Insert exercises
      final exercises = missionData['exercises'] as List<dynamic>? ?? [];
      for (final exercise in exercises) {
        await _insertExercise(
          txn,
          exercise as Map<String, dynamic>,
          missionData['metadata']['id'] as String,
        );
      }

      // 3. Insert vocabulary
      final vocab = missionData['vocabulary'] as Map<String, dynamic>?;
      if (vocab != null) {
        await _insertVocabulary(
          txn,
          vocab,
          missionData['metadata']['id'] as String,
        );
      }

      // 4. Insert dialogue turns
      final dialogue = missionData['dialogue'] as Map<String, dynamic>?;
      if (dialogue != null) {
        await _insertDialogue(
          txn,
          dialogue,
          missionData['metadata']['id'] as String,
        );
      }
    });
  }

  Future<void> _insertMission(
    Transaction txn,
    Map<String, dynamic> data,
  ) async {
    final metadata = data['metadata'] as Map<String, dynamic>;
    final objective = data['learning_objective'] as Map<String, dynamic>?;
    final scenario = data['scenario'] as Map<String, dynamic>?;
    final emotionalGoal = data['emotional_goal'] as Map<String, dynamic>?;
    final yasmina = data['yasmina'] as Map<String, dynamic>?;

    await txn.insert(
      DbConstants.tableMissions,
      {
        'id': metadata['id'],
        'title_en': metadata['title_display_en'] ?? metadata['title_internal'],
        'title_de': metadata['title_display_de'] ?? '',
        'title_darija': metadata['title_display_darija'],
        'module': metadata['module'],
        'sequence': metadata['sequence'],
        'type': metadata['type'],
        'estimated_duration_minutes': metadata['estimated_duration_minutes'],
        'cefr_level': metadata['cefr_level'],
        'cefr_target': metadata['cefr_target'],
        'difficulty': metadata['difficulty'],
        'skills_json': jsonEncode(metadata['skills']),
        'career_domains_json': jsonEncode(metadata['career_domains']),
        'career_relevance_score': metadata['career_relevance_score'] ?? 0,
        'career_contribution_domain':
            (data['confidence_scoring'] as Map<String, dynamic>?)?['career_readiness_contribution']?['domain'],
        'career_contribution_max_percent':
            (data['confidence_scoring'] as Map<String, dynamic>?)?['career_readiness_contribution']?['max_contribution_percent'],
        'learning_objective_en': objective?['statement_en'] ?? '',
        'learning_objective_darija': objective?['statement_darija'],
        'emotional_goal_json':
            emotionalGoal != null ? jsonEncode(emotionalGoal) : null,
        'prerequisites_json':
            jsonEncode(metadata['prerequisites'] ?? []),
        'tags_json': jsonEncode(metadata['tags'] ?? []),
        'yasmina_json': yasmina != null ? jsonEncode(yasmina) : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _insertExercise(
    Transaction txn,
    Map<String, dynamic> exercise,
    String missionId,
  ) async {
    await txn.insert(
      DbConstants.tableExercises,
      {
        'id': exercise['id'],
        'mission_id': missionId,
        'order_index': exercise['order'],
        'type': exercise['type'],
        'phase': exercise['phase'],
        'prompt_text_en': exercise['prompt_text_en'],
        'prompt_text_darija': exercise['prompt_text_darija'],
        'target_text_de': exercise['target_text_de'],
        'target_audio_native': exercise['target_audio_native'],
        'target_audio_slow': exercise['target_audio_slow'],
        'evaluation_mode': exercise['evaluation_mode'],
        'evaluation_config_json':
            jsonEncode(exercise['evaluation_config'] ?? {}),
        'scaffolding_json': jsonEncode(exercise['scaffolding'] ?? {}),
        'feedback_json': jsonEncode(exercise['feedback'] ?? {}),
        'max_attempts': exercise['max_attempts'] ?? 3,
        'time_limit_seconds': exercise['time_limit_seconds'],
        'estimated_duration_seconds':
            exercise['estimated_duration_seconds'] ?? 45,
        'vocabulary_ids_json':
            jsonEncode(exercise['vocabulary_ids'] ?? []),
        'srs_trigger': (exercise['srs_trigger'] == true) ? 1 : 0,
        'dialogue_id': exercise['dialogue_id'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _insertVocabulary(
    Transaction txn,
    Map<String, dynamic> vocab,
    String missionId,
  ) async {
    final categories = ['core', 'supporting', 'review'];

    for (final category in categories) {
      final items = vocab[category] as List<dynamic>? ?? [];
      for (final item in items) {
        final v = item as Map<String, dynamic>;
        final srsConfig = v['srs_config'] as Map<String, dynamic>?;

        await txn.insert(
          DbConstants.tableVocabulary,
          {
            'id': v['id'],
            'mission_id': missionId,
            'chunk_phrase': v['chunk_phrase'],
            'functional_meaning': v['functional_meaning'] ?? '',
            'literal_meaning': v['literal_meaning'],
            'translation_en': v['translation_en'] ?? '',
            'translation_darija': v['translation_darija'],
            'translation_fr': v['translation_fr'],
            'ipa': v['ipa'],
            'audio_native': v['audio_native'] ?? v['audio_path'] ?? '',
            'audio_slow': v['audio_slow'],
            'register': v['register'] ?? 'formal',
            'domain': v['domain'] ?? '',
            'cluster': v['cluster'] ?? '',
            'example_de': (v['example_in_context']
                as Map<String, dynamic>?)?['de'],
            'example_en': (v['example_in_context']
                as Map<String, dynamic>?)?['en'],
            'example_audio': (v['example_in_context']
                as Map<String, dynamic>?)?['audio'],
            'srs_initial_interval_hours':
                srsConfig?['initial_interval_hours'] ?? 12,
            'srs_initial_ease_factor':
                srsConfig?['initial_ease_factor'] ?? 2.5,
            'context_variations_json':
                jsonEncode(srsConfig?['context_variations'] ?? []),
            'category': category,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<void> _insertDialogue(
    Transaction txn,
    Map<String, dynamic> dialogue,
    String missionId,
  ) async {
    final dialogueId = dialogue['id'] as String? ?? 'dlg_$missionId';
    final turns = dialogue['turns'] as List<dynamic>? ?? [];

    for (final turn in turns) {
      final t = turn as Map<String, dynamic>;

      await txn.insert(
        DbConstants.tableConversationTurns,
        {
          'id': '${dialogueId}_t${t['turn']}',
          'dialogue_id': dialogueId,
          'mission_id': missionId,
          'turn_number': t['turn'],
          'speaker': t['speaker'],
          'type': t['type'],
          'speaker_character_id': t['speaker_character_id'],
          'text_de': t['text_de'],
          'text_de_slow': t['text_de_slow'],
          'text_en': t['text_en'] ?? t['translation_en'],
          'text_darija': t['text_darija'] ?? t['translation_darija'],
          'audio_path_native': t['audio_path_native'] ?? t['audio_path'],
          'audio_path_slow': t['audio_path_slow'],
          'audio_path_shadow': t['audio_path_shadow'],
          'pronunciation_notes_json':
              jsonEncode(t['pronunciation_notes'] ?? []),
          'acceptable_responses_json':
              jsonEncode(t['acceptable_responses'] ?? []),
          'comprehension_options_json': jsonEncode(
            (t['comprehension_check'] as Map<String, dynamic>?)?['options'] ?? [],
          ),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
