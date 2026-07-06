import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/mission.dart';
import '../repositories/mission_repository.dart';

/// Loads a complete mission by ID, ready for playback.
///
/// This is the primary use case that drives the mission player.
/// It fetches the full mission data including all exercises,
/// vocabulary, dialogue scripts, and coaching messages.
class LoadMission extends UseCase<Mission, LoadMissionParams> {
  LoadMission(this._repository);

  final MissionRepository _repository;

  @override
  Future<Either<Failure, Mission>> call(LoadMissionParams params) {
    return _repository.getMission(params.missionId);
  }
}

class LoadMissionParams extends Equatable {
  const LoadMissionParams({required this.missionId});

  final String missionId;

  @override
  List<Object?> get props => [missionId];
}
