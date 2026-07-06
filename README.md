# Project Phoenix

**Offline-first German learning application for professional readiness.**

Transforms complete beginners into confident German speakers capable of working in customer service and call centers.

## Target Platforms

- Windows Desktop
- Android APK

## Tech Stack

- Flutter (latest stable)
- Material 3
- SQLite (offline-first)
- BLoC (state management)
- Clean Architecture
- GoRouter (navigation)
- GetIt + Injectable (dependency injection)

## Architecture

```
lib/
├── core/          # Shared infrastructure (theme, router, DI, database, audio)
├── features/      # Feature modules (Clean Architecture per feature)
│   ├── mission/   # Mission loading, playing, and completing
│   └── progress/  # User progress tracking and SRS scheduling
└── engines/       # Pure Dart business logic (SRS, scoring)
```

Each feature follows Clean Architecture:
- `domain/` — Entities, repository interfaces, use cases (pure Dart, no Flutter)
- `data/` — Repository implementations, data sources, models
- `presentation/` — BLoCs, pages, widgets

## Getting Started

### Prerequisites

- Flutter SDK >= 3.22.0
- Dart SDK >= 3.4.0
- Android SDK (for Android builds)
- Visual Studio with C++ workload (for Windows builds)

### Setup

```bash
flutter pub get
flutter run
```

### Running Tests

```bash
flutter test
```

### Building

```bash
# Android APK
flutter build apk --release

# Windows
flutter build windows --release
```

## Project Status

- [x] M0.1 — Project Scaffold
- [ ] M0.2 — Core Infrastructure
- [ ] M0.3 — Mission Engine
- [ ] M0.4 — UI Polish
- [ ] M0.5 — Content & Audio
- [ ] M0.6 — Integration & Polish
