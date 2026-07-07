import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/db_constants.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/srs_item.dart';
import '../models/srs_item_model.dart';

/// Local SQLite datasource for user progress data.
///
/// Performs all database queries related to:
/// - Mission completion records
/// - SRS item scheduling and updates
/// - Daily statistics
/// - Career readiness scores
/// - Resume state persistence
class ProgressLocalDatasource {
  ProgressLocalDatasource(this._provider);

  final DatabaseProvider _provider;

  // ─── Mission Progress ──────────────────────────────────────

  Future<void> saveMissionCompletion({
    required String missionId,
    required double score,
    required String outcome,
    required int speakingTimeSeconds,
    required int totalTimeSeconds,
  }) async {
    try {
      final existing = await _provider.userDb.query(
        DbConstants.tableMissionProgress,
        where: 'mission_id = ?',
        whereArgs: [missionId],
      );

      final attempts =
          existing.isNotEmpty ? (existing.first['attempts'] as int) + 1 : 1;

      await _provider.userDb.insert(
        DbConstants.tableMissionProgress,
        {
          'mission_id': missionId,
          'status': 'completed',
          'score': score,
          'outcome': outcome,
          'completed_at': DateTime.now().toIso8601String(),
          'attempts': attempts,
          'speaking_time_seconds': speakingTimeSeconds,
          'total_time_seconds': totalTimeSeconds,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception catch (e) {
      throw DatabaseException(message: 'Failed to save mission completion: $e');
    }
  }

  Future<int> getCompletedMissionCount() async {
    final result = await _provider.userDb.rawQuery('''
      SELECT COUNT(*) as count FROM ${DbConstants.tableMissionProgress}
      WHERE status = 'completed'
    ''');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getCurrentModule() async {
    final result = await _provider.userDb.rawQuery('''
      SELECT MAX(CAST(SUBSTR(mission_id, 2, 2) AS INTEGER)) as max_module
      FROM ${DbConstants.tableMissionProgress}
      WHERE status = 'completed'
    ''');
    return result.first['max_module'] as int? ?? 1;
  }

  // ─── SRS Items ─────────────────────────────────────────────

  Future<void> insertSrsItems(List<SrsItem> items) async {
    final batch = _provider.userDb.batch();
    for (final item in items) {
      batch.insert(
        DbConstants.tableSrsItems,
        SrsItemModel.toMap(item),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<SrsItem>> getDueItems() async {
    final now = DateTime.now().toIso8601String();
    final results = await _provider.userDb.query(
      DbConstants.tableSrsItems,
      where: 'next_review_at <= ?',
      whereArgs: [now],
      orderBy: 'next_review_at ASC',
      limit: 12,
    );
    return results.map(SrsItemModel.fromMap).toList();
  }

  Future<void> updateSrsItem(SrsItem item) async {
    await _provider.userDb.update(
      DbConstants.tableSrsItems,
      SrsItemModel.toMap(item),
      where: 'item_id = ?',
      whereArgs: [item.itemId],
    );
  }

  Future<int> getTotalVocabularyCount() async {
    final result = await _provider.userDb.rawQuery('''
      SELECT COUNT(*) as count FROM ${DbConstants.tableSrsItems}
    ''');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getMasteredCount() async {
    final result = await _provider.userDb.rawQuery('''
      SELECT COUNT(*) as count FROM ${DbConstants.tableSrsItems}
      WHERE interval_days > 21
    ''');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ─── Career Readiness ──────────────────────────────────────

  Future<Map<String, double>> getCareerScores() async {
    final results = await _provider.userDb.query('career_readiness');
    final scores = <String, double>{};
    for (final row in results) {
      scores[row['domain'] as String] =
          (row['score'] as num).toDouble();
    }
    return scores;
  }

  Future<void> updateCareerScore(String domain, double score) async {
    await _provider.userDb.update(
      'career_readiness',
      {
        'score': score,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'domain = ?',
      whereArgs: [domain],
    );
  }

  // ─── Daily Stats ───────────────────────────────────────────

  Future<void> recordDailyStats({
    required int exercisesCompleted,
    required int speakingTimeSeconds,
    required int totalTimeSeconds,
  }) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final existing = await _provider.userDb.query(
      DbConstants.tableDailyStats,
      where: 'date = ?',
      whereArgs: [today],
    );

    if (existing.isEmpty) {
      await _provider.userDb.insert(DbConstants.tableDailyStats, {
        'date': today,
        'exercises_completed': exercisesCompleted,
        'speaking_time_seconds': speakingTimeSeconds,
        'total_time_seconds': totalTimeSeconds,
      });
    } else {
      await _provider.userDb.rawUpdate('''
        UPDATE ${DbConstants.tableDailyStats}
        SET exercises_completed = exercises_completed + ?,
            speaking_time_seconds = speaking_time_seconds + ?,
            total_time_seconds = total_time_seconds + ?
        WHERE date = ?
      ''', [exercisesCompleted, speakingTimeSeconds, totalTimeSeconds, today]);
    }
  }

  Future<int> getTotalSpeakingTime() async {
    final result = await _provider.userDb.rawQuery('''
      SELECT COALESCE(SUM(speaking_time_seconds), 0) as total
      FROM ${DbConstants.tableDailyStats}
    ''');
    return (result.first['total'] as int?) ?? 0;
  }

  Future<int> getTotalSessions() async {
    final result = await _provider.userDb.rawQuery('''
      SELECT COUNT(*) as count FROM ${DbConstants.tableDailyStats}
      WHERE total_time_seconds > 0
    ''');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ─── Resume State ──────────────────────────────────────────

  Future<void> saveResumeState(String missionId, int exerciseIndex) async {
    await _provider.userDb.insert(
      'resume_state',
      {
        'mission_id': missionId,
        'exercise_index': exerciseIndex,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int?> getResumeState(String missionId) async {
    final results = await _provider.userDb.query(
      'resume_state',
      where: 'mission_id = ?',
      whereArgs: [missionId],
    );
    if (results.isEmpty) return null;
    return results.first['exercise_index'] as int;
  }

  Future<void> clearResumeState(String missionId) async {
    await _provider.userDb.delete(
      'resume_state',
      where: 'mission_id = ?',
      whereArgs: [missionId],
    );
  }

  // ─── Streak Calculation ────────────────────────────────────

  Future<int> calculateCurrentStreak() async {
    final results = await _provider.userDb.query(
      DbConstants.tableDailyStats,
      columns: ['date'],
      where: 'total_time_seconds > 0',
      orderBy: 'date DESC',
      limit: 365,
    );

    if (results.isEmpty) return 0;

    var streak = 0;
    var checkDate = DateTime.now();

    // If today has no entry yet, start checking from yesterday
    final todayStr = checkDate.toIso8601String().substring(0, 10);
    final hasToday = results.any((r) => r['date'] == todayStr);
    if (!hasToday) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    for (final row in results) {
      final dateStr = row['date'] as String;
      final expectedStr = checkDate.toIso8601String().substring(0, 10);

      if (dateStr == expectedStr) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Future<int> getLongestStreak() async {
    // Get setting for longest streak (stored as setting value)
    final result = await _provider.userDb.query(
      'settings',
      where: "key = 'longest_streak'",
    );
    if (result.isEmpty) return 0;
    return int.tryParse(result.first['value'] as String) ?? 0;
  }

  Future<void> updateLongestStreak(int streak) async {
    await _provider.userDb.insert(
      'settings',
      {'key': 'longest_streak', 'value': streak.toString()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DateTime> getLastActiveDate() async {
    final result = await _provider.userDb.query(
      DbConstants.tableDailyStats,
      columns: ['date'],
      orderBy: 'date DESC',
      limit: 1,
    );
    if (result.isEmpty) return DateTime.now();
    return DateTime.parse(result.first['date'] as String);
  }
}
