# Mission Zero — Engineering Plan

## Project Roadmap

### What Mission Zero Delivers

A single, complete, production-quality mission: **"Your phone is ringing. Answer it."**

The learner will:
1. See a professional welcome screen with mission briefing
2. Hear native German audio: "Guten Tag, wie kann ich Ihnen helfen?"
3. Listen to the phrase broken into chunks
4. Repeat each chunk (record themselves)
5. Receive pronunciation evaluation (architecture in place, scoring via audio comparison)
6. Learn 5 vocabulary items in context
7. Complete a smart review round (spaced repetition first pass)
8. Participate in a mini 4-turn conversation simulation
9. See a mission summary with performance data
10. See progress update (Career Readiness movement)

### Engineering Milestones

```
M0.1 — Project Scaffold (this phase)
  ✓ Flutter project creation
  ✓ Folder structure (Clean Architecture)
  ✓ All dependencies configured
  ✓ Database schema implemented
  ✓ Theme system (light + dark)
  ✓ Navigation shell
  ✓ DI container wired
  → GATE: App compiles and runs on Android + Windows

M0.2 — Core Infrastructure
  ✓ Database service (SQLite)
  ✓ Audio engine (playback + recording)
  ✓ Content repository (loads mission data)
  ✓ User progress repository
  → GATE: Can load content from DB and play audio

M0.3 — Mission Engine
  ✓ Mission state machine (BLoC)
  ✓ Exercise state machine (per-exercise BLoC)
  ✓ Exercise type: Listen (audio playback + comprehension)
  ✓ Exercise type: Shadow/Repeat (record + compare)
  ✓ Exercise type: Vocabulary (contextual presentation)
  ✓ Exercise type: Review (SRS-scheduled recall)
  ✓ Exercise type: Conversation (multi-turn dialogue)
  → GATE: Complete mission flow works end-to-end

M0.4 — UI Polish
  ✓ Welcome/briefing screen
  ✓ Exercise screens (all 5 types)
  ✓ Mission summary screen
  ✓ Progress screen
  ✓ Animations and transitions
  ✓ Typography and spacing
  ✓ Dark/light mode complete
  → GATE: Premium visual quality

M0.5 — Content & Audio
  ✓ Mission Zero content authored (DB seed)
  ✓ Placeholder audio files (TTS-generated for development)
  ✓ Vocabulary entries
  ✓ Conversation script
  → GATE: Mission is playable with real content

M0.6 — Integration & Polish
  ✓ Full mission playable start to finish
  ✓ Progress saved to SQLite
  ✓ SRS items scheduled after completion
  ✓ No crashes, no visual glitches
  ✓ Runs on Android APK
  ✓ Runs on Windows
  → GATE: MISSION ZERO COMPLETE
```

### Quality Standards

- Zero `TODO` comments in shipped code
- Zero `print()` debugging statements
- Every public API documented with dartdoc
- Every BLoC has corresponding unit test stubs (structure ready)
- Strict lint rules enforced (`very_good_analysis` equivalent)
- Null safety throughout
- No dynamic typing
- No magic strings (all constants extracted)

### Architecture Constraints

- Domain layer: ZERO Flutter imports (pure Dart)
- Data layer: ZERO UI awareness
- Presentation layer: ZERO direct database access
- All cross-layer communication via repository interfaces
- All state managed through BLoC (no setState, no StatefulWidget for logic)
- All navigation via GoRouter with typed routes
- All DI via GetIt + Injectable

---

## File Tree

```
project_phoenix/
├── android/                              # Android platform (generated)
├── windows/                              # Windows platform (generated)
├── assets/
│   ├── audio/
│   │   ├── missions/
│   │   │   └── mission_zero/
│   │   │       ├── greeting_full.mp3
│   │   │       ├── guten_tag.mp3
│   │   │       ├── wie_kann_ich.mp3
│   │   │       ├── ihnen_helfen.mp3
│   │   │       ├── vocab_guten_tag.mp3
│   │   │       ├── vocab_helfen.mp3
│   │   │       ├── vocab_bitte.mp3
│   │   │       ├── vocab_danke.mp3
│   │   │       ├── vocab_entschuldigung.mp3
│   │   │       ├── convo_customer_01.mp3
│   │   │       ├── convo_customer_02.mp3
│   │   │       ├── convo_customer_03.mp3
│   │   │       └── convo_customer_04.mp3
│   │   └── ui/
│   │       ├── session_start.mp3
│   │       └── exercise_complete.mp3
│   ├── databases/
│   │   └── phoenix_content.db            # Pre-built content database
│   └── fonts/
│       ├── Inter-Regular.ttf
│       ├── Inter-Medium.ttf
│       ├── Inter-SemiBold.ttf
│       ├── Inter-Bold.ttf
│       └── NotoSansArabic-Regular.ttf
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── injection.dart
│   ├── injection.config.dart             # Generated
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── db_constants.dart
│   │   │   └── asset_paths.dart
│   │   ├── error/
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   ├── extensions/
│   │   │   ├── context_extensions.dart
│   │   │   └── string_extensions.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── color_tokens.dart
│   │   │   ├── typography_tokens.dart
│   │   │   └── spacing.dart
│   │   ├── router/
│   │   │   ├── app_router.dart
│   │   │   └── route_names.dart
│   │   ├── database/
│   │   │   ├── database_service.dart
│   │   │   └── database_provider.dart
│   │   ├── audio/
│   │   │   ├── audio_service.dart
│   │   │   └── audio_recorder_service.dart
│   │   └── widgets/
│   │       ├── phoenix_scaffold.dart
│   │       ├── phoenix_button.dart
│   │       ├── phoenix_card.dart
│   │       ├── progress_bar.dart
│   │       ├── audio_wave_widget.dart
│   │       ├── microphone_button.dart
│   │       └── fade_in_widget.dart
│   │
│   ├── features/
│   │   ├── mission/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── mission.dart
│   │   │   │   │   ├── exercise.dart
│   │   │   │   │   ├── exercise_result.dart
│   │   │   │   │   └── mission_result.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── mission_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_mission.dart
│   │   │   │       ├── submit_exercise_result.dart
│   │   │   │       └── complete_mission.dart
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── mission_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── mission_model.dart
│   │   │   │   │   └── exercise_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── mission_repository_impl.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── mission_bloc.dart
│   │   │       │   ├── mission_event.dart
│   │   │       │   └── mission_state.dart
│   │   │       ├── pages/
│   │   │       │   ├── mission_briefing_page.dart
│   │   │       │   ├── mission_player_page.dart
│   │   │       │   └── mission_summary_page.dart
│   │   │       └── widgets/
│   │   │           ├── exercise_container.dart
│   │   │           ├── listen_exercise_widget.dart
│   │   │           ├── repeat_exercise_widget.dart
│   │   │           ├── vocabulary_exercise_widget.dart
│   │   │           ├── review_exercise_widget.dart
│   │   │           ├── conversation_exercise_widget.dart
│   │   │           ├── mission_progress_indicator.dart
│   │   │           └── feedback_overlay.dart
│   │   │
│   │   └── progress/
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   ├── user_progress.dart
│   │       │   │   └── srs_item.dart
│   │       │   ├── repositories/
│   │       │   │   └── progress_repository.dart
│   │       │   └── usecases/
│   │       │       ├── get_progress.dart
│   │       │       ├── update_progress.dart
│   │       │       └── schedule_review.dart
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── progress_local_datasource.dart
│   │       │   ├── models/
│   │       │   │   ├── user_progress_model.dart
│   │       │   │   └── srs_item_model.dart
│   │       │   └── repositories/
│   │       │       └── progress_repository_impl.dart
│   │       └── presentation/
│   │           ├── bloc/
│   │           │   ├── progress_bloc.dart
│   │           │   ├── progress_event.dart
│   │           │   └── progress_state.dart
│   │           └── widgets/
│   │               ├── career_readiness_card.dart
│   │               └── speaking_time_card.dart
│   │
│   └── engines/
│       ├── srs_engine.dart
│       └── scoring_engine.dart
│
├── test/
│   ├── unit/
│   │   ├── engines/
│   │   │   ├── srs_engine_test.dart
│   │   │   └── scoring_engine_test.dart
│   │   └── features/
│   │       ├── mission/
│   │       │   └── domain/
│   │       │       └── usecases/
│   │       └── progress/
│   │           └── domain/
│   │               └── usecases/
│   └── widget/
│       └── features/
│           └── mission/
│               └── presentation/
│
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
└── .gitignore
```

---

## Dependencies

```yaml
# pubspec.yaml — Dependency Plan

name: project_phoenix
description: Offline German learning application for professional readiness.
version: 0.1.0

environment:
  sdk: '>=3.4.0 <4.0.0'
  flutter: '>=3.22.0'

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.6          # BLoC pattern implementation
  bloc: ^8.1.4                  # Core BLoC library
  equatable: ^2.0.5             # Value equality for states/events

  # Dependency Injection
  get_it: ^7.7.0                # Service locator
  injectable: ^2.4.4            # Code generation for DI

  # Navigation
  go_router: ^14.2.7            # Declarative routing

  # Database
  sqflite: ^2.3.3+1             # SQLite for Android
  sqlite3_flutter_libs: ^0.5.24 # SQLite native libs (Windows/Linux)
  path: ^1.9.0                  # Path utilities
  path_provider: ^2.1.4         # Platform-specific paths

  # Audio
  just_audio: ^0.9.40           # Audio playback
  record: ^5.1.2                # Audio recording

  # Functional Programming
  dartz: ^0.10.1                # Either type for error handling

  # UI
  flutter_animate: ^4.5.0       # Declarative animations
  google_fonts: ^6.2.1          # Typography (Inter font)

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.12
  injectable_generator: ^2.6.2

  # Testing
  bloc_test: ^9.1.7             # BLoC testing utilities
  mocktail: ^1.0.4              # Mocking

  # Linting
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true

  assets:
    - assets/audio/missions/mission_zero/
    - assets/audio/ui/
    - assets/databases/

  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
    - family: NotoSansArabic
      fonts:
        - asset: assets/fonts/NotoSansArabic-Regular.ttf
```

### Dependency Rationale

| Package | Why This One | Alternatives Rejected |
|---------|-------------|----------------------|
| flutter_bloc | Complex state machines (mission flow), testable, strict patterns | Riverpod (less structured for multi-step flows), Provider (too simple) |
| get_it + injectable | Compile-time DI safety, minimal boilerplate | manual DI (error-prone), riverpod (different paradigm) |
| go_router | Typed routes, deep linking ready, official package | auto_route (heavier), Navigator 2.0 raw (verbose) |
| sqflite + sqlite3_flutter_libs | Cross-platform SQLite (Android + Windows) | drift (overkill for our schema), hive (no SQL) |
| just_audio | Best Flutter audio player, supports all formats, low latency | audioplayers (less maintained), assets_audio_player (limited) |
| record | Cross-platform recording, WAV output | flutter_sound (heavy), audio_recorder (abandoned) |
| dartz | Either<Failure, T> for clean error handling | fpdart (newer but less adopted), try/catch (no typed errors) |
| flutter_animate | Declarative animation chains, production-quality | manual AnimationController (verbose), rive (overkill) |
| equatable | Value equality for BLoC states without boilerplate | freezed (generates too much), manual == (error-prone) |

---

## Package Structure (Clean Architecture)

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                            │
│  lib/features/*/presentation/                                    │
│                                                                   │
│  ┌──────────┐  ┌──────────────┐  ┌───────────────────────────┐ │
│  │  Pages   │  │   Widgets    │  │      BLoCs                │ │
│  │(screens) │  │(components)  │  │ (state + events + logic)  │ │
│  └──────────┘  └──────────────┘  └───────────────────────────┘ │
│        │              │                      │                    │
│        └──────────────┴──────────────────────┘                   │
│                        DEPENDS ON ↓                               │
├─────────────────────────────────────────────────────────────────┤
│                       DOMAIN LAYER                                │
│  lib/features/*/domain/                                          │
│  lib/engines/                                                    │
│                                                                   │
│  ┌──────────┐  ┌──────────────┐  ┌───────────────────────────┐ │
│  │ Entities │  │  Use Cases   │  │  Repository Interfaces    │ │
│  │(models)  │  │  (actions)   │  │  (abstract contracts)     │ │
│  └──────────┘  └──────────────┘  └───────────────────────────┘ │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                   ENGINES (Pure Dart)                         │ │
│  │   SRS Engine  |  Scoring Engine                              │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                        DEPENDS ON ↓                               │
├─────────────────────────────────────────────────────────────────┤
│                        DATA LAYER                                 │
│  lib/features/*/data/                                            │
│  lib/core/database/                                              │
│  lib/core/audio/                                                 │
│                                                                   │
│  ┌──────────┐  ┌──────────────┐  ┌───────────────────────────┐ │
│  │  Models  │  │ Datasources  │  │  Repository Impls         │ │
│  │(DB DTOs) │  │  (SQLite)    │  │  (implement interfaces)   │ │
│  └──────────┘  └──────────────┘  └───────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Dependency Rule (ENFORCED)

- `domain/` imports NOTHING from `data/` or `presentation/`
- `data/` imports from `domain/` only (to implement interfaces)
- `presentation/` imports from `domain/` only (via use cases)
- `engines/` import NOTHING from Flutter (pure Dart)
- `core/` is shared infrastructure available to all layers

### Feature Boundaries

| Feature | Responsibility | BLoCs |
|---------|---------------|-------|
| `mission` | Loading, playing, and completing missions | `MissionBloc` |
| `progress` | Tracking user progress, SRS scheduling | `ProgressBloc` |

### Use Case Pattern

```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
```

Every use case:
- Takes a specific Params object
- Returns Either<Failure, T> (never throws)
- Does ONE thing
- Coordinates between repository and engine if needed

---

## Database Schema

### Two Databases

| Database | Purpose | Access |
|----------|---------|--------|
| `phoenix_content.db` | All educational content (missions, exercises, vocab) | READ-ONLY, ships with app |
| `phoenix_user.db` | User progress, SRS items, statistics | READ-WRITE, created on first launch |

### Content Database (phoenix_content.db)

```sql
-- Missions
CREATE TABLE missions (
    id TEXT PRIMARY KEY,
    module_id TEXT NOT NULL,
    order_index INTEGER NOT NULL,
    title_de TEXT NOT NULL,
    title_en TEXT NOT NULL,
    briefing_en TEXT NOT NULL,
    briefing_darija TEXT,
    estimated_minutes INTEGER NOT NULL DEFAULT 10,
    difficulty INTEGER NOT NULL DEFAULT 1 CHECK(difficulty BETWEEN 1 AND 5)
);

-- Exercises within missions
CREATE TABLE exercises (
    id TEXT PRIMARY KEY,
    mission_id TEXT NOT NULL REFERENCES missions(id),
    order_index INTEGER NOT NULL,
    exercise_type TEXT NOT NULL CHECK(exercise_type IN (
        'listen', 'repeat', 'vocabulary', 'review', 'conversation'
    )),
    prompt_text TEXT,
    prompt_audio_path TEXT,
    correct_text TEXT,
    correct_audio_path TEXT,
    translation_en TEXT,
    translation_darija TEXT,
    hints TEXT,              -- JSON array of hint strings
    metadata TEXT            -- JSON for exercise-type-specific data
);

-- Vocabulary items
CREATE TABLE vocabulary (
    id TEXT PRIMARY KEY,
    word_de TEXT NOT NULL,
    translation_en TEXT NOT NULL,
    translation_darija TEXT,
    phonetic_ipa TEXT,
    audio_path TEXT NOT NULL,
    example_sentence_de TEXT,
    example_audio_path TEXT,
    part_of_speech TEXT,
    article TEXT,
    difficulty INTEGER NOT NULL DEFAULT 1
);

-- Vocabulary-to-mission linking
CREATE TABLE mission_vocabulary (
    mission_id TEXT NOT NULL REFERENCES missions(id),
    vocabulary_id TEXT NOT NULL REFERENCES vocabulary(id),
    order_index INTEGER NOT NULL,
    PRIMARY KEY (mission_id, vocabulary_id)
);

-- Conversation scripts
CREATE TABLE conversation_turns (
    id TEXT PRIMARY KEY,
    mission_id TEXT NOT NULL REFERENCES missions(id),
    order_index INTEGER NOT NULL,
    speaker TEXT NOT NULL CHECK(speaker IN ('customer', 'agent')),
    text_de TEXT NOT NULL,
    audio_path TEXT,
    translation_en TEXT,
    acceptable_responses TEXT,   -- JSON array (for agent turns)
    mood_value INTEGER DEFAULT 70
);

-- Indices
CREATE INDEX idx_exercises_mission ON exercises(mission_id, order_index);
CREATE INDEX idx_vocab_mission ON mission_vocabulary(mission_id, order_index);
CREATE INDEX idx_convo_mission ON conversation_turns(mission_id, order_index);
```

### User Database (phoenix_user.db)

```sql
-- User profile
CREATE TABLE user_profile (
    id INTEGER PRIMARY KEY DEFAULT 1,
    display_name TEXT DEFAULT '',
    native_language TEXT DEFAULT 'darija',
    daily_goal_minutes INTEGER DEFAULT 25,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    last_active_at TEXT
);

-- Mission progress
CREATE TABLE mission_progress (
    mission_id TEXT PRIMARY KEY,
    status TEXT NOT NULL DEFAULT 'available' CHECK(status IN (
        'locked', 'available', 'in_progress', 'completed'
    )),
    score REAL,
    completed_at TEXT,
    attempts INTEGER DEFAULT 0,
    speaking_time_seconds INTEGER DEFAULT 0
);

-- Exercise attempts (detailed log)
CREATE TABLE exercise_attempts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    exercise_id TEXT NOT NULL,
    attempted_at TEXT NOT NULL DEFAULT (datetime('now')),
    score REAL NOT NULL DEFAULT 0.0,
    time_spent_seconds INTEGER DEFAULT 0,
    user_response TEXT,
    recording_path TEXT
);

-- SRS items (spaced repetition)
CREATE TABLE srs_items (
    item_id TEXT PRIMARY KEY,
    item_type TEXT NOT NULL CHECK(item_type IN ('vocabulary', 'phrase')),
    ease_factor REAL NOT NULL DEFAULT 2.5,
    interval_days REAL NOT NULL DEFAULT 1.0,
    repetitions INTEGER NOT NULL DEFAULT 0,
    next_review_at TEXT NOT NULL,
    last_reviewed_at TEXT,
    correct_streak INTEGER DEFAULT 0,
    lapses INTEGER DEFAULT 0
);

-- Daily statistics
CREATE TABLE daily_stats (
    date TEXT PRIMARY KEY,
    missions_completed INTEGER DEFAULT 0,
    exercises_completed INTEGER DEFAULT 0,
    speaking_time_seconds INTEGER DEFAULT 0,
    new_vocabulary_learned INTEGER DEFAULT 0,
    total_time_seconds INTEGER DEFAULT 0
);

-- Indices
CREATE INDEX idx_srs_next_review ON srs_items(next_review_at);
CREATE INDEX idx_exercise_attempts_exercise ON exercise_attempts(exercise_id);
CREATE INDEX idx_daily_stats_date ON daily_stats(date);
```

---

## State Management Plan

### BLoC Architecture for Mission Zero

```
┌───────────────────────────────────────────────────────────────┐
│                    APP-LEVEL                                    │
│                                                                │
│  ThemeCubit (light/dark mode toggle)                          │
│  → States: ThemeState(themeMode)                              │
│                                                                │
└───────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────┐
│                    MISSION FEATURE                              │
│                                                                │
│  MissionBloc                                                   │
│  ─────────────────────────────────────────────────────────────│
│  Events:                                                       │
│    LoadMission(missionId)                                      │
│    StartMission()                                              │
│    SubmitExercise(exerciseId, response)                        │
│    NextExercise()                                              │
│    SkipExercise()                                              │
│    PlayAudio(audioPath)                                        │
│    StartRecording()                                            │
│    StopRecording()                                             │
│    CompleteMission()                                           │
│                                                                │
│  States:                                                       │
│    MissionInitial                                              │
│    MissionLoading                                              │
│    MissionBriefing(mission)                                    │
│    MissionInProgress(                                          │
│      mission,                                                  │
│      currentExerciseIndex,                                     │
│      totalExercises,                                           │
│      currentExercise,                                          │
│      exerciseState: ExercisePhase,                             │
│    )                                                           │
│    MissionCompleted(missionResult)                             │
│    MissionError(failure)                                       │
│                                                                │
│  ExercisePhase (sub-state within MissionInProgress):           │
│    presenting    — showing the exercise prompt                 │
│    listening     — audio is playing                            │
│    recording     — user is speaking                            │
│    evaluating    — scoring the response                        │
│    feedback      — showing result + model                      │
│    transitioning — moving to next exercise                     │
│                                                                │
└───────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────┐
│                   PROGRESS FEATURE                              │
│                                                                │
│  ProgressBloc                                                  │
│  ─────────────────────────────────────────────────────────────│
│  Events:                                                       │
│    LoadProgress()                                              │
│    RecordMissionCompletion(missionId, score, speakingTime)     │
│    ScheduleReviewItems(List<vocabularyIds>)                    │
│                                                                │
│  States:                                                       │
│    ProgressInitial                                             │
│    ProgressLoaded(                                             │
│      missionsCompleted,                                        │
│      totalSpeakingTime,                                        │
│      vocabularyLearned,                                        │
│      careerReadinessPercent,                                   │
│      currentStreak,                                            │
│    )                                                           │
│    ProgressError(failure)                                      │
│                                                                │
└───────────────────────────────────────────────────────────────┘
```

### State Flow for Mission Zero

```
App Launch
  → MissionBloc: LoadMission('mission_zero')
  → State: MissionLoading → MissionBriefing

User taps "Start Mission"
  → MissionBloc: StartMission()
  → State: MissionInProgress(exerciseIndex: 0, phase: presenting)

Exercise Flow (repeats for each exercise):
  → Exercise presented (phase: presenting)
  → Audio plays (phase: listening) — for listen/repeat types
  → User records (phase: recording) — for repeat type
  → System evaluates (phase: evaluating)
  → Feedback shown (phase: feedback)
  → User taps "Next" → NextExercise()
  → State: MissionInProgress(exerciseIndex: +1, phase: presenting)

Last exercise completed:
  → MissionBloc: CompleteMission()
  → State: MissionCompleted(missionResult)
  → ProgressBloc: RecordMissionCompletion(...)
  → ProgressBloc: ScheduleReviewItems(vocabIds)
```

### BLoC Communication Pattern

```
MissionBloc ──(domain event)──→ ProgressBloc

MissionBloc does NOT talk to ProgressBloc directly.
Instead:
  1. MissionBloc calls CompleteMission use case
  2. CompleteMission use case writes to ProgressRepository
  3. The UI (BlocListener on MissionCompleted state) 
     triggers ProgressBloc.add(RecordMissionCompletion(...))
  
This maintains BLoC independence.
```

---

## Summary

This plan delivers:
- **Scalable architecture** that supports hundreds of missions without structural changes
- **Clean separation** where adding a new exercise type means one new widget + one evaluator function
- **Offline-first** with all content in SQLite + local audio assets
- **Premium quality** with proper theming, animations, and typography
- **Testability** with every business logic component independently testable

The next step is code generation, beginning with the Flutter project scaffold.
