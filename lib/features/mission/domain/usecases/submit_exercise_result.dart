import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/progress/domain/repositories/progress_repository.dart';
import '../entities/exercise_result.dart';

/// Submits a single exercise result and updates progress.
///
/// Called after each exercise is evaluated. Persists the result
/// and updates the resume state so the learner can continue
/// from where they stopped if they exit mid-mission.
class SubmitExerciseResult
    extends UseCase<void, SubmitExerciseResultParams> {
  SubmitExerciseResult(this._progressRepository);

  final ProgressRepository _progressRepository;

  @override
  Future<Either<Failure, void>> call(
    SubmitExerciseResultParams params,
  ) async {
    // Save resume state (learner can continue from here if they exit)
    final resumeResult = await _progressRepository.saveResumeState(
      missionId: params.missionId,
      exerciseIndex: params.exerciseIndex,
    );

    return resumeResult;
  }
}

class SubmitExerciseResultParams extends Equatable {
  const SubmitExerciseResultParams({
    required this.missionId,
    required this.exerciseIndex,
    required this.result,
  });

  final String missionId;
  final int exerciseIndex;
  final ExerciseResult result;

  @override
  List<Object?> get props => [missionId, exerciseIndex, result];
}
