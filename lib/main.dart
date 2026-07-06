import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/database/database_service.dart';
import 'core/database/content_seeder.dart';
import 'core/database/mission_zero_seed.dart';
import 'injection.dart';

/// Application entry point.
///
/// Initialization is split into two phases for optimal perceived performance:
///
/// Phase 1 (IMMEDIATE — before first frame):
/// - Flutter binding
/// - System UI configuration
/// - DI container registration (synchronous, no I/O)
/// - App widget launched (splash screen appears instantly)
///
/// Phase 2 (DEFERRED — during splash screen):
/// - Database initialization (async, disk I/O)
/// - Content seeding (async, disk I/O)
/// - Audio engine warm-up
///
/// This ensures the splash screen appears in < 300ms regardless
/// of database state, then heavy initialization happens in parallel.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Phase 1: Immediate (no I/O, no awaits that block first frame)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Register DI container (synchronous — no I/O)
  configureDependencies();

  // Launch app immediately (splash screen renders first)
  runApp(const PhoenixApp());

  // Phase 2: Deferred heavy initialization (runs AFTER first frame)
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await _initializeServices();
  });
}

/// Heavy initialization that runs during splash screen display.
Future<void> _initializeServices() async {
  // Initialize databases (creates schemas on first launch)
  final databaseService = sl<DatabaseService>();
  await databaseService.initialize();

  // Seed Mission Zero content (idempotent — safe to run multiple times)
  final contentSeeder = sl<ContentSeeder>();
  await contentSeeder.seedMission(missionZeroData);
}
