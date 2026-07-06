import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/mission/presentation/bloc/mission_bloc.dart';
import '../../features/mission/presentation/bloc/mission_event.dart';
import '../../features/mission/presentation/pages/mission_briefing_page.dart';
import '../../features/mission/presentation/pages/mission_player_page.dart';
import '../../features/mission/presentation/pages/mission_summary_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../injection.dart';
import '../audio/audio_recorder_service.dart';
import '../audio/audio_service.dart';
import '../yasmina/yasmina_service.dart';
import '../../engines/scoring_engine.dart';
import '../../features/mission/domain/usecases/complete_mission.dart';
import '../../features/mission/domain/usecases/load_mission.dart';
import '../../features/mission/domain/usecases/submit_exercise_result.dart';
import '../../features/progress/domain/repositories/progress_repository.dart';
import 'route_names.dart';

/// Application router configuration.
///
/// Uses GoRouter for declarative routing with typed paths.
/// Provides all screens needed for Mission Zero playthrough.
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: RouteNames.home,
      redirect: (context, state) => '/home',
    ),
    GoRoute(
      path: RouteNames.missionBriefing,
      builder: (context, state) {
        final missionId = state.pathParameters['missionId']!;
        return BlocProvider(
          create: (_) => MissionBloc(
            loadMission: sl<LoadMission>(),
            submitExerciseResult: sl<SubmitExerciseResult>(),
            completeMission: sl<CompleteMission>(),
            audioService: sl<AudioService>(),
            recorderService: sl<AudioRecorderService>(),
            yasminaService: sl<YasminaService>(),
            scoringEngine: sl<ScoringEngine>(),
            progressRepository: sl<ProgressRepository>(),
          )..add(LoadMissionEvent(missionId: missionId)),
          child: const MissionBriefingPage(),
        );
      },
    ),
    GoRoute(
      path: RouteNames.missionPlayer,
      builder: (context, state) => const MissionPlayerPage(),
    ),
    GoRoute(
      path: RouteNames.missionSummary,
      builder: (context, state) => const MissionSummaryPage(),
    ),
  ],
);

// PhoenixHomeShell removed — replaced by features/home/presentation/pages/home_page.dart
