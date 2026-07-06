import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/srs_item.dart';
import '../entities/user_progress.dart';

/// Contract for user progress data access.
///
/// Handles all persistence of learner progress, SRS items,
/// statistics, and career readiness calculations.
abstract class ProgressRepository {
  /// Get the current overall user progress.
  Future<Either<Failure, UserProgress>> getProgress();

  /// Update progress after a mission is completed.
  Future<Either<Failure, void>> recordMissionCompletion({
    required String missionId,
    required double score,
    required int speakingTimeSeconds,
    required int totalTimeSeconds,
    required int newVocabularyCount,
    required String careerDomain,
    required double careerContribution,
  });

  /// Schedule new vocabulary items for SRS review.
  Future<Either<Failure, void>> scheduleReviewItems(
    List<SrsItem> items,
  );

  /// Get all SRS items that are currently due for review.
  Future<Either<Failure, List<SrsItem>>> getDueReviewItems();

  /// Update an SRS item after a review event.
  Future<Either<Failure, void>> updateSrsItem(SrsItem updatedItem);

  /// Get the total count of vocabulary items in SRS.
  Future<Either<Failure, int>> getTotalVocabularyCount();

  /// Get the count of mastered items (interval > 21 days).
  Future<Either<Failure, int>> getMasteredVocabularyCount();

  /// Record daily statistics.
  Future<Either<Failure, void>> recordDailyStats({
    required int exercisesCompleted,
    required int speakingTimeSeconds,
    required int totalTimeSeconds,
  });

  /// Update the learner's streak.
  Future<Either<Failure, void>> updateStreak();

  /// Save the resume state (which exercise the learner stopped at).
  Future<Either<Failure, void>> saveResumeState({
    required String missionId,
    required int exerciseIndex,
  });

  /// Get the resume state for a mission (null if not started).
  Future<Either<Failure, int?>> getResumeState(String missionId);

  /// Clear the resume state after mission completion.
  Future<Either<Failure, void>> clearResumeState(String missionId);
}
