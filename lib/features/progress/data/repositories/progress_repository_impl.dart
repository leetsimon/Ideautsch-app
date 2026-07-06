import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/srs_item.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_local_datasource.dart';
import '../models/user_progress_model.dart';

/// Concrete implementation of [ProgressRepository].
///
/// Coordinates between the datasource and domain layer,
/// handling error conversion (exceptions → failures).
class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._datasource);

  final ProgressLocalDatasource _datasource;

  @override
  Future<Either<Failure, UserProgress>> getProgress() async {
    try {
      final missionsCompleted =
          await _datasource.getCompletedMissionCount();
      final speakingTime = await _datasource.getTotalSpeakingTime();
      final vocabLearned = await _datasource.getTotalVocabularyCount();
      final vocabMastered = await _datasource.getMasteredCount();
      final careerScores = await _datasource.getCareerScores();
      final currentStreak = await _datasource.calculateCurrentStreak();
      final longestStreak = await _datasource.getLongestStreak();
      final totalSessions = await _datasource.getTotalSessions();
      final currentModule = await _datasource.getCurrentModule();
      final lastActive = await _datasource.getLastActiveDate();

      final progress = UserProgressModel.fromQueryResults(
        missionsCompleted: missionsCompleted,
        totalSpeakingTimeSeconds: speakingTime,
        vocabularyLearned: vocabLearned,
        vocabularyMastered: vocabMastered,
        careerScores: careerScores,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        totalSessions: totalSessions,
        currentModule: currentModule,
        lastActiveDate: lastActive,
      );

      return Right(progress);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> recordMissionCompletion({
    required String missionId,
    required double score,
    required int speakingTimeSeconds,
    required int totalTimeSeconds,
    required int newVocabularyCount,
    required String careerDomain,
    required double careerContribution,
  }) async {
    try {
      // Save mission completion
      await _datasource.saveMissionCompletion(
        missionId: missionId,
        score: score,
        outcome: _scoreToOutcome(score),
        speakingTimeSeconds: speakingTimeSeconds,
        totalTimeSeconds: totalTimeSeconds,
      );

      // Update career readiness
      final currentScores = await _datasource.getCareerScores();
      final currentDomainScore = currentScores[careerDomain] ?? 0.0;
      final newScore = currentDomainScore + careerContribution;
      await _datasource.updateCareerScore(
        careerDomain,
        newScore.clamp(0.0, 100.0),
      );

      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> scheduleReviewItems(
    List<SrsItem> items,
  ) async {
    try {
      await _datasource.insertSrsItems(items);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<SrsItem>>> getDueReviewItems() async {
    try {
      final items = await _datasource.getDueItems();
      return Right(items);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateSrsItem(SrsItem updatedItem) async {
    try {
      await _datasource.updateSrsItem(updatedItem);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalVocabularyCount() async {
    try {
      final count = await _datasource.getTotalVocabularyCount();
      return Right(count);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getMasteredVocabularyCount() async {
    try {
      final count = await _datasource.getMasteredCount();
      return Right(count);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> recordDailyStats({
    required int exercisesCompleted,
    required int speakingTimeSeconds,
    required int totalTimeSeconds,
  }) async {
    try {
      await _datasource.recordDailyStats(
        exercisesCompleted: exercisesCompleted,
        speakingTimeSeconds: speakingTimeSeconds,
        totalTimeSeconds: totalTimeSeconds,
      );
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateStreak() async {
    try {
      final currentStreak = await _datasource.calculateCurrentStreak();
      final longestStreak = await _datasource.getLongestStreak();
      if (currentStreak > longestStreak) {
        await _datasource.updateLongestStreak(currentStreak);
      }
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveResumeState({
    required String missionId,
    required int exerciseIndex,
  }) async {
    try {
      await _datasource.saveResumeState(missionId, exerciseIndex);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, int?>> getResumeState(String missionId) async {
    try {
      final index = await _datasource.getResumeState(missionId);
      return Right(index);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearResumeState(String missionId) async {
    try {
      await _datasource.clearResumeState(missionId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  String _scoreToOutcome(double score) {
    if (score >= 0.80) return 'accomplished';
    if (score >= 0.60) return 'completed';
    if (score >= 0.40) return 'advanced';
    return 'attempted';
  }
}
