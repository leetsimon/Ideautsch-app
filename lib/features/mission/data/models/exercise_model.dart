import 'dart:convert';

import '../../domain/entities/exercise.dart';

/// Data model for Exercise — handles SQLite ↔ Domain mapping.
///
/// Converts between the flat JSON/SQLite representation and
/// the rich domain entity with typed enums and nested objects.
class ExerciseModel {
  const ExerciseModel._();

  /// Convert a SQLite row map to a domain [Exercise] entity.
  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      type: _parseExerciseType(map['type'] as String),
      order: map['order_index'] as int,
      phase: _parsePhase(map['phase'] as String),
      promptTextEn: map['prompt_text_en'] as String,
      promptTextDarija: map['prompt_text_darija'] as String?,
      targetTextDe: map['target_text_de'] as String?,
      targetAudioNative: map['target_audio_native'] as String?,
      targetAudioSlow: map['target_audio_slow'] as String?,
      evaluationMode: _parseEvalMode(map['evaluation_mode'] as String),
      evaluationConfig: _parseEvalConfig(
        map['evaluation_config_json'] as String,
      ),
      scaffolding: _parseScaffolding(map['scaffolding_json'] as String),
      feedback: _parseFeedback(map['feedback_json'] as String),
      maxAttempts: map['max_attempts'] as int,
      timeLimitSeconds: map['time_limit_seconds'] as int?,
      estimatedDurationSeconds: map['estimated_duration_seconds'] as int,
      vocabularyIds: _parseStringList(
        map['vocabulary_ids_json'] as String? ?? '[]',
      ),
      srsTrigger: (map['srs_trigger'] as int?) == 1,
      dialogueId: map['dialogue_id'] as String?,
    );
  }

  /// Convert a domain [Exercise] entity to a SQLite-compatible map.
  static Map<String, dynamic> toMap(Exercise exercise, String missionId) {
    return {
      'id': exercise.id,
      'mission_id': missionId,
      'order_index': exercise.order,
      'type': exercise.type.name,
      'phase': exercise.phase.name,
      'prompt_text_en': exercise.promptTextEn,
      'prompt_text_darija': exercise.promptTextDarija,
      'target_text_de': exercise.targetTextDe,
      'target_audio_native': exercise.targetAudioNative,
      'target_audio_slow': exercise.targetAudioSlow,
      'evaluation_mode': exercise.evaluationMode.name,
      'evaluation_config_json': _encodeEvalConfig(exercise.evaluationConfig),
      'scaffolding_json': _encodeScaffolding(exercise.scaffolding),
      'feedback_json': _encodeFeedback(exercise.feedback),
      'max_attempts': exercise.maxAttempts,
      'time_limit_seconds': exercise.timeLimitSeconds,
      'estimated_duration_seconds': exercise.estimatedDurationSeconds,
      'vocabulary_ids_json': jsonEncode(exercise.vocabularyIds),
      'srs_trigger': exercise.srsTrigger ? 1 : 0,
      'dialogue_id': exercise.dialogueId,
    };
  }

  static ExerciseType _parseExerciseType(String value) {
    return ExerciseType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ExerciseType.shadow,
    );
  }

  static ExercisePhase _parsePhase(String value) {
    return ExercisePhase.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ExercisePhase.equip,
    );
  }

  static EvaluationMode _parseEvalMode(String value) {
    return EvaluationMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EvaluationMode.pronunciationMatch,
    );
  }

  static EvaluationConfig _parseEvalConfig(String jsonStr) {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return EvaluationConfig(
      minimumScore: (map['minimum_score'] as num?)?.toDouble() ?? 0.45,
      keywordsRequired: _parseStringList(
        jsonEncode(map['keywords_required'] ?? []),
      ),
      keywordsOptional: _parseStringList(
        jsonEncode(map['keywords_optional'] ?? []),
      ),
      pronunciationWeight:
          (map['pronunciation_weight'] as num?)?.toDouble() ?? 0.6,
      completenessWeight:
          (map['completeness_weight'] as num?)?.toDouble() ?? 0.4,
      speedWeight: (map['speed_weight'] as num?)?.toDouble() ?? 0.0,
      comprehensionOptions: _parseComprehensionOptions(map),
      expectedText: map['expected_text'] as String?,
      dialogueId: map['dialogue_id'] as String?,
      weightPerTurn: _parseWeightPerTurn(map),
    );
  }

  static List<ComprehensionOption> _parseComprehensionOptions(
    Map<String, dynamic> map,
  ) {
    final options = map['options'] as List<dynamic>?;
    if (options == null) return [];
    return options.map((o) {
      final optMap = o as Map<String, dynamic>;
      return ComprehensionOption(
        textEn: optMap['text_en'] as String? ?? optMap['text'] as String? ?? '',
        textDarija: optMap['text_darija'] as String?,
        isCorrect: optMap['correct'] as bool? ?? false,
      );
    }).toList();
  }

  static Map<int, double> _parseWeightPerTurn(Map<String, dynamic> map) {
    final weights = map['weight_per_turn'] as Map<String, dynamic>?;
    if (weights == null) return {};
    return weights.map(
      (key, value) => MapEntry(
        int.tryParse(key.replaceAll('turn_', '')) ?? 0,
        (value as num).toDouble(),
      ),
    );
  }

  static Scaffolding _parseScaffolding(String jsonStr) {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return Scaffolding(
      supportHigh: _parseScaffoldLevel(
        map['support_high'] as Map<String, dynamic>? ?? {},
      ),
      supportStandard: _parseScaffoldLevel(
        map['support_standard'] as Map<String, dynamic>? ?? {},
      ),
      supportMinimal: _parseScaffoldLevel(
        map['support_minimal'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  static ScaffoldLevel _parseScaffoldLevel(Map<String, dynamic> map) {
    return ScaffoldLevel(
      textVisible: map['text_visible'] as bool? ?? false,
      audioModelFirst: map['audio_model_first'] as bool? ?? false,
      hintAvailable: map['hint_available'] as bool? ?? false,
      hintText: map['hint_text'] as String?,
      wordBank: (map['word_bank'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      firstWordsVisible: map['first_words_visible'] as bool? ?? false,
      firstWords: (map['first_words'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  static ExerciseFeedback _parseFeedback(String jsonStr) {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return ExerciseFeedback(
      onSuccess: map['on_success'] as String? ?? '',
      onPartial: map['on_partial'] as String? ?? '',
      onRetry: map['on_retry'] as String? ?? '',
      onSuccessDarija: map['on_success_darija'] as String?,
    );
  }

  static String _encodeEvalConfig(EvaluationConfig config) {
    return jsonEncode({
      'minimum_score': config.minimumScore,
      'keywords_required': config.keywordsRequired,
      'keywords_optional': config.keywordsOptional,
      'pronunciation_weight': config.pronunciationWeight,
      'completeness_weight': config.completenessWeight,
      'speed_weight': config.speedWeight,
      'expected_text': config.expectedText,
      'dialogue_id': config.dialogueId,
      'options': config.comprehensionOptions
          .map((o) => {
                'text_en': o.textEn,
                'text_darija': o.textDarija,
                'correct': o.isCorrect,
              })
          .toList(),
      'weight_per_turn': config.weightPerTurn.map(
        (k, v) => MapEntry('turn_$k', v),
      ),
    });
  }

  static String _encodeScaffolding(Scaffolding scaffolding) {
    return jsonEncode({
      'support_high': _encodeScaffoldLevel(scaffolding.supportHigh),
      'support_standard': _encodeScaffoldLevel(scaffolding.supportStandard),
      'support_minimal': _encodeScaffoldLevel(scaffolding.supportMinimal),
    });
  }

  static Map<String, dynamic> _encodeScaffoldLevel(ScaffoldLevel level) {
    return {
      'text_visible': level.textVisible,
      'audio_model_first': level.audioModelFirst,
      'hint_available': level.hintAvailable,
      'hint_text': level.hintText,
      'word_bank': level.wordBank,
      'first_words_visible': level.firstWordsVisible,
      'first_words': level.firstWords,
    };
  }

  static String _encodeFeedback(ExerciseFeedback feedback) {
    return jsonEncode({
      'on_success': feedback.onSuccess,
      'on_partial': feedback.onPartial,
      'on_retry': feedback.onRetry,
      'on_success_darija': feedback.onSuccessDarija,
    });
  }

  static List<String> _parseStringList(String jsonStr) {
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list.map((e) => e as String).toList();
  }
}
