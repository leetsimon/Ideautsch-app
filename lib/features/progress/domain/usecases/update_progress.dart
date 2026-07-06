import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/progress_repository.dart';

/// Records a mission completion in the progress system.
///
/// Updates career readiness, vocabulary counts, speaking time,
/// and streak data.
class UpdateProgress extends UseCase<void, UpdateProgressParams> {
  UpdateProgress(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Either<Failure, void>> call(UpdateProgressParams params) {
    return _repository.recordMissionCompletion(
      missionId: params.missionId,
      score: params.score,
      speakingTimeSeconds: params.speakingTimeSeconds,
      totalTimeSeconds: params.totalTimeSeconds,
      newVocabularyCount: params.newVocabularyCount,
      careerDomain: params.careerDomain,
      careerContribution: params.careerContribution,
    );
  }
}

class UpdateProgressParams extends Equatable {
  const UpdateProgressParams({
    required this.missionId,
    required this.score,
    required this.speakingTimeSeconds,
    required this.totalTimeSeconds,
    required this.newVocabularyCount,
    required this.careerDomain,
    required this.careerContribution,
  });

  final String missionId;
  final double score;
  final int speakingTimeSeconds;
  final int totalTimeSeconds;
  final int newVocabularyCount;
  final String careerDomain;
  final double careerContribution;

  @override
  List<Object?> get props => [missionId, score, speakingTimeSeconds];
}
