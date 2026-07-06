import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/srs_item.dart';
import '../repositories/progress_repository.dart';

/// Schedules new vocabulary items for spaced repetition review.
///
/// Called after a mission completes. Creates SRS entries for
/// newly learned vocabulary with appropriate initial intervals.
class ScheduleReviewItems
    extends UseCase<void, ScheduleReviewItemsParams> {
  ScheduleReviewItems(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Either<Failure, void>> call(ScheduleReviewItemsParams params) {
    return _repository.scheduleReviewItems(params.items);
  }
}

class ScheduleReviewItemsParams extends Equatable {
  const ScheduleReviewItemsParams({required this.items});

  final List<SrsItem> items;

  @override
  List<Object?> get props => [items.length];
}
