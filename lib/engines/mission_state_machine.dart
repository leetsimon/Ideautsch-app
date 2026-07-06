import '../features/mission/domain/entities/exercise.dart';
import '../features/mission/domain/entities/exercise_result.dart';
import '../features/mission/domain/entities/mission.dart';

/// The current phase of an exercise within the mission flow.
enum ExercisePlayState {
  /// Exercise is being presented (prompt shown, waiting for learner).
  presenting,

  /// Audio model is playing.
  playingAudio,

  /// Learner is recording their response.
  recording,

  /// System is evaluating the learner's response.
  evaluating,

  /// Feedback is being shown to the learner.
  showingFeedback,

  /// Transitioning to the next exercise.
  transitioning,
}

/// The current support level being used for adaptive difficulty.
enum SupportLevel {
  high,
  standard,
  minimal,
}

/// Manages the state machine that controls mission flow.
///
/// Determines:
/// - Which exercise comes next
/// - What support level to use
/// - When to offer hints
/// - When to suggest ending early
/// - Whether to offer a stretch challenge
///
/// Pure Dart — no Flutter dependencies.
class MissionStateMachine {
  MissionStateMachine({
    required this.mission,
    this.startAtExercise = 0,
  })  : _currentIndex = startAtExercise,
        _supportLevel = SupportLevel.high;

  /// The mission being played.
  final Mission mission;

  /// Exercise index to start from (for resume).
  final int startAtExercise;

  /// Current exercise index.
  int _currentIndex;

  /// Current adaptive support level.
  SupportLevel _supportLevel;

  /// Accumulated exercise results.
  final List<ExerciseResult> _results = [];

  /// Consecutive scores below threshold (for de-escalation).
  int _consecutiveLowScores = 0;

  /// Consecutive scores above threshold (for escalation).
  int _consecutiveHighScores = 0;

  // ─── Public Getters ────────────────────────────────────────────

  /// Current exercise index (0-based).
  int get currentIndex => _currentIndex;

  /// Current exercise.
  Exercise get currentExercise => mission.exercises[_currentIndex];

  /// Whether there are more exercises after the current one.
  bool get hasNext => _currentIndex < mission.exercises.length - 1;

  /// Whether the mission is complete (all exercises done).
  bool get isComplete => _currentIndex >= mission.exercises.length;

  /// Current support level.
  SupportLevel get supportLevel => _supportLevel;

  /// All accumulated results so far.
  List<ExerciseResult> get results => List.unmodifiable(_results);

  /// Progress fraction (0.0–1.0).
  double get progress =>
      mission.exercises.isEmpty
          ? 0.0
          : (_currentIndex + 1) / mission.exercises.length;

  /// Total exercises in the mission.
  int get totalExercises => mission.exercises.length;

  // ─── State Transitions ─────────────────────────────────────────

  /// Record an exercise result and advance the state.
  ///
  /// Returns true if there are more exercises, false if mission is done.
  bool submitResult(ExerciseResult result) {
    _results.add(result);
    _updateAdaptiveDifficulty(result);

    if (hasNext) {
      _currentIndex++;
      return true;
    }

    return false;
  }

  /// Skip to the next exercise without recording a result.
  bool skipExercise() {
    if (hasNext) {
      _currentIndex++;
      return true;
    }
    return false;
  }

  /// Get the scaffolding level to use for the current exercise.
  ScaffoldLevel getCurrentScaffolding() {
    switch (_supportLevel) {
      case SupportLevel.high:
        return currentExercise.scaffolding.supportHigh;
      case SupportLevel.standard:
        return currentExercise.scaffolding.supportStandard;
      case SupportLevel.minimal:
        return currentExercise.scaffolding.supportMinimal;
    }
  }

  /// Whether a stretch challenge should be offered at mission end.
  bool get shouldOfferStretchChallenge {
    if (_results.length < 5) return false;
    final avgScore = _results.fold<double>(0.0, (s, r) => s + r.score) /
        _results.length;
    return avgScore >= 0.80;
  }

  /// Whether a recovery mission should be suggested.
  bool get shouldSuggestRecovery {
    if (_results.length < 3) return false;
    final recentScores = _results.reversed.take(3).map((r) => r.score);
    return recentScores.every((s) => s < 0.40);
  }

  // ─── Private Adaptive Logic ────────────────────────────────────

  void _updateAdaptiveDifficulty(ExerciseResult result) {
    if (result.score >= 0.70) {
      _consecutiveHighScores++;
      _consecutiveLowScores = 0;
    } else if (result.score < 0.40) {
      _consecutiveLowScores++;
      _consecutiveHighScores = 0;
    } else {
      _consecutiveHighScores = 0;
      _consecutiveLowScores = 0;
    }

    // Escalate: reduce support after 3+ high scores
    if (_consecutiveHighScores >= 3 &&
        _supportLevel != SupportLevel.minimal) {
      _supportLevel = SupportLevel.values[_supportLevel.index + 1];
      _consecutiveHighScores = 0;
    }

    // De-escalate: increase support after 2+ low scores
    if (_consecutiveLowScores >= 2 &&
        _supportLevel != SupportLevel.high) {
      _supportLevel = SupportLevel.values[_supportLevel.index - 1];
      _consecutiveLowScores = 0;
    }
  }
}
