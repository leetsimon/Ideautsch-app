import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/mission.dart';
import '../entities/mission_result.dart';

/// Contract for mission data access.
///
/// The domain layer depends on this interface. The data layer
/// provides the concrete implementation (SQLite + YAML parser).
abstract class MissionRepository {
  /// Load a complete mission by its ID.
  ///
  /// Returns the full [Mission] object with all exercises,
  /// vocabulary, dialogue, and coaching messages.
  Future<Either<Failure, Mission>> getMission(String missionId);

  /// Get all available missions with basic metadata.
  ///
  /// Used by the mission selection screen. Does NOT load
  /// full exercise/vocabulary data (lightweight query).
  Future<Either<Failure, List<Mission>>> getAllMissions();

  /// Get missions for a specific module.
  Future<Either<Failure, List<Mission>>> getMissionsByModule(int module);

  /// Save a completed mission result.
  ///
  /// Persists the [MissionResult] to the user database
  /// and triggers SRS scheduling for new vocabulary.
  Future<Either<Failure, void>> saveMissionResult(MissionResult result);

  /// Get the saved result for a previously completed mission.
  ///
  /// Returns null-equivalent failure if mission hasn't been completed.
  Future<Either<Failure, MissionResult>> getMissionResult(String missionId);

  /// Check if a mission's prerequisites are satisfied.
  Future<Either<Failure, bool>> arePrerequisitesMet(String missionId);
}
