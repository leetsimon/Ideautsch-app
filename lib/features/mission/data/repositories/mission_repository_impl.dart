import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/mission.dart';
import '../../domain/entities/mission_result.dart';
import '../../domain/repositories/mission_repository.dart';
import '../datasources/mission_local_datasource.dart';

/// Concrete implementation of [MissionRepository].
///
/// Assembles complete Mission entities by combining data
/// from missions, exercises, vocabulary, and dialogue tables.
class MissionRepositoryImpl implements MissionRepository {
  MissionRepositoryImpl(this._datasource);

  final MissionLocalDatasource _datasource;

  @override
  Future<Either<Failure, Mission>> getMission(String missionId) async {
    try {
      // Load metadata
      final metadata = await _datasource.getMissionMetadata(missionId);

      // Load exercises
      final exercises =
          await _datasource.getExercisesForMission(missionId);

      // Load vocabulary
      final vocabulary =
          await _datasource.getVocabularyForMission(missionId);

      // Load dialogue
      final dialogue =
          await _datasource.getDialogueForMission(missionId);

      // Assemble complete Mission entity
      final mission = Mission(
        id: metadata.id,
        titleEn: metadata.titleEn,
        titleDe: metadata.titleDe,
        titleDarija: metadata.titleDarija,
        module: metadata.module,
        sequence: metadata.sequence,
        type: metadata.type,
        estimatedDurationMinutes: metadata.estimatedDurationMinutes,
        cefrLevel: metadata.cefrLevel,
        cefrTarget: metadata.cefrTarget,
        difficulty: metadata.difficulty,
        skills: metadata.skills,
        careerDomains: metadata.careerDomains,
        learningObjectiveEn: metadata.learningObjectiveEn,
        learningObjectiveDarija: metadata.learningObjectiveDarija,
        emotionalGoal: metadata.emotionalGoal,
        exercises: exercises,
        vocabulary: vocabulary,
        dialogue: dialogue,
        yasminaMessages: metadata.yasminaMessages,
        careerContribution: metadata.careerContribution,
        prerequisites: metadata.prerequisites,
        tags: metadata.tags,
      );

      return Right(mission);
    } on ContentNotFoundException catch (e) {
      return Left(ContentNotFoundFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Mission>>> getAllMissions() async {
    try {
      final metadataList = await _datasource.getAllMissions();

      // For the list view, we create lightweight Mission objects
      // without loading all exercises/vocab/dialogue
      final missions = metadataList
          .map((m) => Mission(
                id: m.id,
                titleEn: m.titleEn,
                titleDe: m.titleDe,
                titleDarija: m.titleDarija,
                module: m.module,
                sequence: m.sequence,
                type: m.type,
                estimatedDurationMinutes: m.estimatedDurationMinutes,
                cefrLevel: m.cefrLevel,
                cefrTarget: m.cefrTarget,
                difficulty: m.difficulty,
                skills: m.skills,
                careerDomains: m.careerDomains,
                learningObjectiveEn: m.learningObjectiveEn,
                learningObjectiveDarija: m.learningObjectiveDarija,
                emotionalGoal: m.emotionalGoal,
                exercises: const [],
                vocabulary: const [],
                careerContribution: m.careerContribution,
                prerequisites: m.prerequisites,
                tags: m.tags,
              ))
          .toList();

      return Right(missions);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Mission>>> getMissionsByModule(
    int module,
  ) async {
    try {
      final metadataList = await _datasource.getMissionsByModule(module);

      final missions = metadataList
          .map((m) => Mission(
                id: m.id,
                titleEn: m.titleEn,
                titleDe: m.titleDe,
                module: m.module,
                sequence: m.sequence,
                type: m.type,
                estimatedDurationMinutes: m.estimatedDurationMinutes,
                cefrLevel: m.cefrLevel,
                cefrTarget: m.cefrTarget,
                difficulty: m.difficulty,
                skills: m.skills,
                careerDomains: m.careerDomains,
                learningObjectiveEn: m.learningObjectiveEn,
                emotionalGoal: m.emotionalGoal,
                exercises: const [],
                vocabulary: const [],
                careerContribution: m.careerContribution,
              ))
          .toList();

      return Right(missions);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveMissionResult(
    MissionResult result,
  ) async {
    // Mission results are saved via the ProgressRepository
    // (which handles the user database). This method exists
    // for interface compliance — the actual write goes through
    // ProgressLocalDatasource.saveMissionCompletion().
    return const Right(null);
  }

  @override
  Future<Either<Failure, MissionResult>> getMissionResult(
    String missionId,
  ) async {
    // Mission results are retrieved via the ProgressRepository.
    // This is a placeholder that returns a not-found failure,
    // as the actual data lives in the user DB not content DB.
    return const Left(
      ContentNotFoundFailure(
        message: 'Mission result retrieval should use ProgressRepository',
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> arePrerequisitesMet(
    String missionId,
  ) async {
    try {
      final metadata = await _datasource.getMissionMetadata(missionId);

      if (metadata.prerequisites.isEmpty) {
        return const Right(true);
      }

      // Check each prerequisite against the progress DB
      // For now, all prerequisites are considered met
      // (full implementation requires cross-DB query in Step 3)
      return const Right(true);
    } on ContentNotFoundException catch (e) {
      return Left(ContentNotFoundFailure(message: e.message));
    }
  }
}
