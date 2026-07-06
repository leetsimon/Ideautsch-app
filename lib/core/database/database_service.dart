import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/db_constants.dart';

/// Manages SQLite database lifecycle for both content and user databases.
///
/// The content database ships pre-built with the app and is READ-ONLY.
/// The user database is created on first launch and stores all progress.
///
/// This service handles:
/// - Database initialization and opening
/// - Schema creation (user DB)
/// - Schema migration (version upgrades)
/// - Database closure on app termination
class DatabaseService {
  Database? _userDb;
  Database? _contentDb;

  /// Whether the databases have been initialized.
  bool get isInitialized => _userDb != null;

  /// The user database instance (read-write).
  Database get userDb {
    if (_userDb == null) {
      throw StateError(
        'DatabaseService not initialized. Call initialize() first.',
      );
    }
    return _userDb!;
  }

  /// The content database instance (read-only).
  Database get contentDb {
    if (_contentDb == null) {
      throw StateError(
        'DatabaseService not initialized. Call initialize() first.',
      );
    }
    return _contentDb!;
  }

  /// Initialize both databases.
  ///
  /// Must be called once during app startup before any
  /// database operations.
  Future<void> initialize() async {
    final dbPath = await _getDatabasePath();
    await _initializeUserDb(dbPath);
    await _initializeContentDb(dbPath);
  }

  /// Close both databases gracefully.
  Future<void> close() async {
    await _userDb?.close();
    await _contentDb?.close();
    _userDb = null;
    _contentDb = null;
  }

  Future<String> _getDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbDir = Directory(join(directory.path, 'phoenix_db'));
    if (!dbDir.existsSync()) {
      await dbDir.create(recursive: true);
    }
    return dbDir.path;
  }

  Future<void> _initializeUserDb(String dbPath) async {
    final path = join(dbPath, DbConstants.userDbName);

    _userDb = await openDatabase(
      path,
      version: DbConstants.userDbVersion,
      onCreate: _createUserSchema,
      onUpgrade: _upgradeUserSchema,
    );
  }

  Future<void> _initializeContentDb(String dbPath) async {
    final path = join(dbPath, DbConstants.contentDbName);

    // Content DB is created fresh if it doesn't exist
    // (will be seeded by ContentSeeder)
    _contentDb = await openDatabase(
      path,
      version: DbConstants.contentDbVersion,
      onCreate: _createContentSchema,
      readOnly: false, // Writable during seeding, read-only after
    );
  }

  /// Create the user database schema.
  Future<void> _createUserSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DbConstants.tableUserProfile} (
        id INTEGER PRIMARY KEY DEFAULT 1,
        display_name TEXT DEFAULT '',
        native_language TEXT DEFAULT 'darija',
        explanation_language TEXT DEFAULT 'english',
        daily_goal_minutes INTEGER DEFAULT 25,
        created_at TEXT NOT NULL DEFAULT (datetime('now')),
        last_active_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.tableMissionProgress} (
        mission_id TEXT PRIMARY KEY,
        status TEXT NOT NULL DEFAULT 'available',
        score REAL,
        outcome TEXT,
        completed_at TEXT,
        attempts INTEGER DEFAULT 0,
        speaking_time_seconds INTEGER DEFAULT 0,
        total_time_seconds INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.tableExerciseAttempts} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_id TEXT NOT NULL,
        mission_id TEXT NOT NULL,
        attempted_at TEXT NOT NULL DEFAULT (datetime('now')),
        score REAL NOT NULL DEFAULT 0.0,
        outcome TEXT NOT NULL DEFAULT 'skipped',
        attempt_number INTEGER NOT NULL DEFAULT 1,
        time_spent_seconds INTEGER DEFAULT 0,
        transcription TEXT,
        keywords_matched TEXT,
        keywords_missed TEXT,
        pronunciation_score REAL DEFAULT 0.0,
        latency_ms INTEGER DEFAULT 0,
        recording_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.tableSrsItems} (
        item_id TEXT PRIMARY KEY,
        item_type TEXT NOT NULL DEFAULT 'vocabulary',
        ease_factor REAL NOT NULL DEFAULT 2.5,
        interval_days REAL NOT NULL DEFAULT 0.5,
        repetitions INTEGER NOT NULL DEFAULT 0,
        next_review_at TEXT NOT NULL,
        last_reviewed_at TEXT,
        correct_streak INTEGER DEFAULT 0,
        lapses INTEGER DEFAULT 0,
        total_reviews INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.tableDailyStats} (
        date TEXT PRIMARY KEY,
        missions_completed INTEGER DEFAULT 0,
        exercises_completed INTEGER DEFAULT 0,
        speaking_time_seconds INTEGER DEFAULT 0,
        new_vocabulary_learned INTEGER DEFAULT 0,
        total_time_seconds INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE resume_state (
        mission_id TEXT PRIMARY KEY,
        exercise_index INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE career_readiness (
        domain TEXT PRIMARY KEY,
        score REAL NOT NULL DEFAULT 0.0,
        updated_at TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Indices
    await db.execute('''
      CREATE INDEX idx_srs_next_review 
        ON ${DbConstants.tableSrsItems}(next_review_at)
    ''');

    await db.execute('''
      CREATE INDEX idx_exercise_attempts_mission 
        ON ${DbConstants.tableExerciseAttempts}(mission_id, exercise_id)
    ''');

    // Seed default user profile
    await db.insert(DbConstants.tableUserProfile, {
      'id': 1,
      'display_name': '',
      'native_language': 'darija',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Seed default career domains
    for (final domain in [
      'phone_communication',
      'customer_handling',
      'professional_language',
      'speaking_fluency',
      'interview_readiness',
    ]) {
      await db.insert('career_readiness', {
        'domain': domain,
        'score': 0.0,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Create the content database schema.
  Future<void> _createContentSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DbConstants.tableMissions} (
        id TEXT PRIMARY KEY,
        title_en TEXT NOT NULL,
        title_de TEXT NOT NULL,
        title_darija TEXT,
        module INTEGER NOT NULL,
        sequence INTEGER NOT NULL,
        type TEXT NOT NULL,
        estimated_duration_minutes INTEGER NOT NULL,
        cefr_level TEXT NOT NULL,
        cefr_target TEXT NOT NULL,
        difficulty INTEGER NOT NULL,
        skills_json TEXT NOT NULL,
        career_domains_json TEXT NOT NULL,
        career_relevance_score INTEGER DEFAULT 0,
        career_contribution_domain TEXT,
        career_contribution_max_percent REAL DEFAULT 0.0,
        learning_objective_en TEXT NOT NULL,
        learning_objective_darija TEXT,
        emotional_goal_json TEXT,
        prerequisites_json TEXT DEFAULT '[]',
        tags_json TEXT DEFAULT '[]',
        yasmina_json TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.tableExercises} (
        id TEXT PRIMARY KEY,
        mission_id TEXT NOT NULL,
        order_index INTEGER NOT NULL,
        type TEXT NOT NULL,
        phase TEXT NOT NULL,
        prompt_text_en TEXT NOT NULL,
        prompt_text_darija TEXT,
        target_text_de TEXT,
        target_audio_native TEXT,
        target_audio_slow TEXT,
        evaluation_mode TEXT NOT NULL,
        evaluation_config_json TEXT NOT NULL,
        scaffolding_json TEXT NOT NULL,
        feedback_json TEXT NOT NULL,
        max_attempts INTEGER NOT NULL DEFAULT 3,
        time_limit_seconds INTEGER,
        estimated_duration_seconds INTEGER NOT NULL,
        vocabulary_ids_json TEXT DEFAULT '[]',
        srs_trigger INTEGER DEFAULT 0,
        dialogue_id TEXT,
        FOREIGN KEY (mission_id) REFERENCES ${DbConstants.tableMissions}(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.tableVocabulary} (
        id TEXT PRIMARY KEY,
        mission_id TEXT NOT NULL,
        chunk_phrase TEXT NOT NULL,
        functional_meaning TEXT NOT NULL,
        literal_meaning TEXT,
        translation_en TEXT NOT NULL,
        translation_darija TEXT,
        translation_fr TEXT,
        ipa TEXT,
        audio_native TEXT NOT NULL,
        audio_slow TEXT,
        register TEXT NOT NULL DEFAULT 'formal',
        domain TEXT NOT NULL,
        cluster TEXT NOT NULL,
        example_de TEXT,
        example_en TEXT,
        example_audio TEXT,
        srs_initial_interval_hours INTEGER DEFAULT 12,
        srs_initial_ease_factor REAL DEFAULT 2.5,
        context_variations_json TEXT DEFAULT '[]',
        category TEXT DEFAULT 'core',
        FOREIGN KEY (mission_id) REFERENCES ${DbConstants.tableMissions}(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.tableConversationTurns} (
        id TEXT PRIMARY KEY,
        dialogue_id TEXT NOT NULL,
        mission_id TEXT NOT NULL,
        turn_number INTEGER NOT NULL,
        speaker TEXT NOT NULL,
        type TEXT NOT NULL,
        speaker_character_id TEXT,
        text_de TEXT,
        text_de_slow TEXT,
        text_en TEXT,
        text_darija TEXT,
        audio_path_native TEXT,
        audio_path_slow TEXT,
        audio_path_shadow TEXT,
        pronunciation_notes_json TEXT DEFAULT '[]',
        acceptable_responses_json TEXT DEFAULT '[]',
        comprehension_options_json TEXT DEFAULT '[]',
        FOREIGN KEY (mission_id) REFERENCES ${DbConstants.tableMissions}(id)
      )
    ''');

    // Indices for content queries
    await db.execute('''
      CREATE INDEX idx_exercises_mission 
        ON ${DbConstants.tableExercises}(mission_id, order_index)
    ''');

    await db.execute('''
      CREATE INDEX idx_vocabulary_mission 
        ON ${DbConstants.tableVocabulary}(mission_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_turns_dialogue 
        ON ${DbConstants.tableConversationTurns}(dialogue_id, turn_number)
    ''');

    await db.execute('''
      CREATE INDEX idx_missions_module 
        ON ${DbConstants.tableMissions}(module, sequence)
    ''');
  }

  /// Handle user database schema upgrades.
  Future<void> _upgradeUserSchema(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Future migrations go here.
    // Example:
    // if (oldVersion < 2) { await _migrateV1ToV2(db); }
  }
}
