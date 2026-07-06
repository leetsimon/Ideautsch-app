import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_progress.dart';
import '../repositories/progress_repository.dart';

/// Retrieves the current overall user progress.
///
/// Used by the home screen, progress dashboard, and
/// career readiness display.
class GetProgress extends UseCase<UserProgress, NoParams> {
  GetProgress(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Either<Failure, UserProgress>> call(NoParams params) {
    return _repository.getProgress();
  }
}
