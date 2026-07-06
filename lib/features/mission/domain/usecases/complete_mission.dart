import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../engines/scoring_engine.dart';
import '../../../../features/progress/domain/entities/srs_item.dart';
import '../../../../features/progress/domain/repositories/progress_repository.dart';
import '../entities/exercise_result.dart';
import '../entities/mission.dart';
import '../entities/mission_result.dart';
import '../repositories/mission_repository.dart';

/// Completes a mission: calculates score, determines outcome,
/// saves result, schedules SRS items, and updates career readiness.
///
/// This is the culminating use case called when the learner
/// finishes all exercises in a mission.
class CompleteMission extends UseCase<MissionResult, CompleteMissionParams> {
  CompleteMission(
    this._missionRepository,
    this._progressRepository,
    this._scoringEngine,
  );

  final MissionRepository _missionRepository;
  final ProgressRepository _progressRepository;
  final ScoringEngine _scoringEngine;

  @override
  Future<Either<Failure, MissionResult>> call(
    CompleteMissionParams params,
  ) async {
    // Calculate overall score and outcome
    final overallScore = _scoringEngine.calculateMissionScore(
      exerciseResults: params.exerciseResults,
      mission: params.mission,
    );

    final outcome = _scoringEngine.determineOutcome(overallScore);

    final dimensionScores = _scoringEngine.calculateDimensionScores(
      exerciseResults: params.exerciseResults,
      mission: params.mission,
    );

    // Calculate career readiness contribution
    final careerContribution = overallScore *
        params.mission.careerContribution.maxContributionPercent;

    // Build the mission result
    final result = MissionResult(
      missionId: params.mission.id,
      outcome: outcome,
      overallScore: overallScore,
      exerciseResults: params.exerciseResults,
      dimensionScores: dimensionScores,
      totalSpeakingTimeSeconds: params.totalSpeakingTimeSeconds,
      totalTimeSeconds: params.totalTimeSeconds,
      careerReadinessContribution: careerContribution,
      newVocabularyLearned: params.newVocabularyIds.length,
      completedAt: DateTime.now(),
    );

    // Persist the mission result
    final saveResult = await _missionRepository.saveMissionResult(result);
    if (saveResult.isLeft()) {
      return Left(
        saveResult.fold((l) => l, (_) => const UnexpectedFailure(message: '')),
      );
    }

    // Record completion in progress tracking
    await _progressRepository.recordMissionCompletion(
      missionId: params.mission.id,
      score: overallScore,
      speakingTimeSeconds: params.totalSpeakingTimeSeconds,
      totalTimeSeconds: params.totalTimeSeconds,
      newVocabularyCount: params.newVocabularyIds.length,
      careerDomain: params.mission.careerContribution.domain,
      careerContribution: careerContribution,
    );

    // Schedule new vocabulary for SRS
    if (params.newVocabularyIds.isNotEmpty) {
      final srsItems = params.newVocabularyIds.map((vocabId) {
        final vocab = params.mission.vocabulary.firstWhere(
          (v) => v.id == vocabId,
        );
        return SrsItem(
          itemId: vocabId,
          itemType: SrsItemType.vocabulary,
          easeFactor: vocab.srsInitialEaseFactor,
          intervalDays: vocab.srsInitialIntervalHours / 24.0,
          repetitions: 0,
          nextReviewAt: DateTime.now().add(
            Duration(hours: vocab.srsInitialIntervalHours),
          ),
        );
      }).toList();

      await _progressRepository.scheduleReviewItems(srsItems);
    }

    // Clear the resume state (mission is done)
    await _progressRepository.clearResumeState(params.mission.id);

    // Update daily stats
    await _progressRepository.recordDailyStats(
      exercisesCompleted: params.exerciseResults.length,
      speakingTimeSeconds: params.totalSpeakingTimeSeconds,
      totalTimeSeconds: params.totalTimeSeconds,
    );

    // Update streak
    await _progressRepository.updateStreak();

    return Right(result);
  }
}

class CompleteMissionParams extends Equatable {
  const CompleteMissionParams({
    required this.mission,
    required this.exerciseResults,
    required this.totalSpeakingTimeSeconds,
    required this.totalTimeSeconds,
    required this.newVocabularyIds,
  });

  final Mission mission;
  final List<ExerciseResult> exerciseResults;
  final int totalSpeakingTimeSeconds;
  final int totalTimeSeconds;
  final List<String> newVocabularyIds;

  @override
  List<Object?> get props => [
        mission.id,
        exerciseResults.length,
        totalSpeakingTimeSeconds,
      ];
}
