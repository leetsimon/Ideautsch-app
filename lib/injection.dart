import 'package:get_it/get_it.dart';

import 'core/audio/audio_recorder_service.dart';
import 'core/audio/audio_service.dart';
import 'core/database/content_seeder.dart';
import 'core/database/database_provider.dart';
import 'core/database/database_service.dart';
import 'core/yasmina/yasmina_service.dart';
import 'engines/scoring_engine.dart';
import 'engines/srs_engine.dart';
import 'features/mission/data/datasources/mission_local_datasource.dart';
import 'features/mission/data/repositories/mission_repository_impl.dart';
import 'features/mission/domain/repositories/mission_repository.dart';
import 'features/mission/domain/usecases/complete_mission.dart';
import 'features/mission/domain/usecases/load_mission.dart';
import 'features/mission/domain/usecases/submit_exercise_result.dart';
import 'features/progress/data/datasources/progress_local_datasource.dart';
import 'features/progress/data/repositories/progress_repository_impl.dart';
import 'features/progress/domain/repositories/progress_repository.dart';
import 'features/progress/domain/usecases/get_progress.dart';
import 'features/progress/domain/usecases/schedule_review_items.dart';
import 'features/progress/domain/usecases/update_progress.dart';

/// Global service locator instance.
///
/// All dependencies are registered here and resolved throughout
/// the application via [sl].
final GetIt sl = GetIt.instance;

/// Configures all application dependencies.
///
/// Called once during app initialization in [main].
/// Registration order:
/// 1. External services (database, audio)
/// 2. Engines (pure business logic)
/// 3. Data sources
/// 4. Repositories
/// 5. Use cases
/// 6. Services (Yasmina, content seeder)
///
/// BLoCs are registered in Step 4 when the presentation layer is built.
void configureDependencies() {
  // ─── 1. External Services ────────────────────────────────────
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());
  sl.registerLazySingleton<DatabaseProvider>(
    () => DatabaseProvider(sl<DatabaseService>()),
  );
  sl.registerLazySingleton<AudioService>(() => AudioService());
  sl.registerLazySingleton<AudioRecorderService>(
    () => AudioRecorderService(),
  );

  // ─── 2. Engines ──────────────────────────────────────────────
  sl.registerLazySingleton<SrsEngine>(() => const SrsEngine());
  sl.registerLazySingleton<ScoringEngine>(() => const ScoringEngine());

  // ─── 3. Data Sources ─────────────────────────────────────────
  sl.registerLazySingleton<MissionLocalDatasource>(
    () => MissionLocalDatasource(sl<DatabaseProvider>()),
  );
  sl.registerLazySingleton<ProgressLocalDatasource>(
    () => ProgressLocalDatasource(sl<DatabaseProvider>()),
  );

  // ─── 4. Repositories ─────────────────────────────────────────
  sl.registerLazySingleton<MissionRepository>(
    () => MissionRepositoryImpl(sl<MissionLocalDatasource>()),
  );
  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(sl<ProgressLocalDatasource>()),
  );

  // ─── 5. Use Cases ────────────────────────────────────────────
  sl.registerLazySingleton<LoadMission>(
    () => LoadMission(sl<MissionRepository>()),
  );
  sl.registerLazySingleton<SubmitExerciseResult>(
    () => SubmitExerciseResult(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<CompleteMission>(
    () => CompleteMission(
      sl<MissionRepository>(),
      sl<ProgressRepository>(),
      sl<ScoringEngine>(),
    ),
  );
  sl.registerLazySingleton<GetProgress>(
    () => GetProgress(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<UpdateProgress>(
    () => UpdateProgress(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<ScheduleReviewItems>(
    () => ScheduleReviewItems(sl<ProgressRepository>()),
  );

  // ─── 6. Services ─────────────────────────────────────────────
  sl.registerLazySingleton<YasminaService>(() => YasminaService());
  sl.registerLazySingleton<ContentSeeder>(
    () => ContentSeeder(sl<DatabaseProvider>()),
  );
}
