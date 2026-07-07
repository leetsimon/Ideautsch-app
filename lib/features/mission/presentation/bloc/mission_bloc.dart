import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/audio/audio_recorder_service.dart';
import '../../../../core/audio/audio_service.dart';
import '../../../../core/yasmina/yasmina_service.dart';
import '../../../../engines/mission_state_machine.dart';
import '../../../../engines/scoring_engine.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_result.dart';
import '../../domain/entities/mission.dart';
import '../../domain/usecases/complete_mission.dart';
import '../../domain/usecases/load_mission.dart';
import '../../domain/usecases/submit_exercise_result.dart';
import '../../../progress/domain/repositories/progress_repository.dart';
import 'mission_event.dart';
import 'mission_state.dart';

/// BLoC that orchestrates the entire mission playback experience.
///
/// Manages the flow from loading → briefing → exercise sequence →
/// completion. Coordinates between the mission state machine,
/// audio services, scoring engine, and Yasmina coaching system.
class MissionBloc extends Bloc<MissionEvent, MissionState> {
  MissionBloc({
    required LoadMission loadMission,
    required SubmitExerciseResult submitExerciseResult,
    required CompleteMission completeMission,
    required AudioService audioService,
    required AudioRecorderService recorderService,
    required YasminaService yasminaService,
    required ScoringEngine scoringEngine,
    required ProgressRepository progressRepository,
  })  : _loadMission = loadMission,
        _submitExerciseResult = submitExerciseResult,
        _completeMission = completeMission,
        _audioService = audioService,
        _recorderService = recorderService,
        _yasminaService = yasminaService,
        _scoringEngine = scoringEngine,
        _progressRepository = progressRepository,
        super(const MissionInitial()) {
    on<LoadMissionEvent>(_onLoadMission);
    on<StartMissionEvent>(_onStartMission);
    on<PlayAudioEvent>(_onPlayAudio);
    on<StartRecordingEvent>(_onStartRecording);
    on<StopRecordingEvent>(_onStopRecording);
    on<SubmitExerciseEvent>(_onSubmitExercise);
    on<SelectAnswerEvent>(_onSelectAnswer);
    on<SubmitTextEvent>(_onSubmitText);
    on<NextExerciseEvent>(_onNextExercise);
    on<RequestHintEvent>(_onRequestHint);
    on<RetryExerciseEvent>(_onRetryExercise);
    on<CompleteMissionEvent>(_onCompleteMission);
    on<DismissYasminaEvent>(_onDismissYasmina);
    on<PauseMissionEvent>(_onPauseMission);
    on<ResumeMissionEvent>(_onResumeMission);
  }

  final LoadMission _loadMission;
  final SubmitExerciseResult _submitExerciseResult;
  final CompleteMission _completeMission;
  final AudioService _audioService;
  final AudioRecorderService _recorderService;
  final YasminaService _yasminaService;
  final ScoringEngine _scoringEngine;
  final ProgressRepository _progressRepository;

  MissionStateMachine? _stateMachine;
  DateTime? _missionStartTime;
  int _totalSpeakingSeconds = 0;
  DateTime? _recordingStartTime;
  final List<String> _newVocabularyIds = [];

  // ─── Event Handlers ────────────────────────────────────────

  Future<void> _onLoadMission(
    LoadMissionEvent event,
    Emitter<MissionState> emit,
  ) async {
    emit(const MissionLoading());

    final result = await _loadMission(
      LoadMissionParams(missionId: event.missionId),
    );

    // FIXED: Do NOT use fold() with async callbacks.
    // fold() does not await async lambdas, causing emit-after-complete.
    if (result.isLeft()) {
      final failure = result.fold((l) => l, (_) => null)!;
      emit(MissionError(message: failure.message));
      return;
    }

    final mission = result.fold((_) => null, (r) => r)!;

    // These are all awaited within the handler — safe to emit after.
    final resumeResult =
        await _progressRepository.getResumeState(mission.id);
    final resumeIndex = resumeResult.fold((_) => null, (idx) => idx);

    _yasminaService.updateModeForModule(mission.module);

    final greeting = _yasminaService.getSessionGreeting(
      missionMessages: mission.yasminaMessages,
      currentModule: mission.module,
    );

    emit(MissionBriefing(
      mission: mission,
      yasminaGreeting: greeting,
      resumeExerciseIndex: resumeIndex,
    ));
  }

  Future<void> _onStartMission(
    StartMissionEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionBriefing) return;

    final mission = currentState.mission;

    // Guard: mission must have exercises to play
    if (mission.exercises.isEmpty) {
      emit(const MissionError(
        message: 'Mission has no exercises. Content may not be loaded correctly.',
      ));
      return;
    }

    final startAt = currentState.resumeExerciseIndex ?? 0;

    _stateMachine = MissionStateMachine(
      mission: mission,
      startAtExercise: startAt,
    );
    _missionStartTime = DateTime.now();
    _totalSpeakingSeconds = 0;
    _newVocabularyIds.clear();

    _emitCurrentExercise(emit, mission);
  }

  Future<void> _onPlayAudio(
    PlayAudioEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionInProgress) return;

    emit(currentState.copyWith(phase: ExercisePlayPhase.playingAudio));

    final audioPath = event.audioPath ??
        currentState.currentExercise.targetAudioNative;

    if (audioPath != null) {
      try {
        await _audioService.playAsset(audioPath, speed: event.speed);
        await _audioService.waitForCompletion();
      } catch (_) {
        // Audio asset not available — skip silently.
        // This is expected during development when placeholder files exist.
      }
    }

    // Only emit if still in the same state (not disposed/changed)
    if (!emit.isDone) {
      emit(currentState.copyWith(phase: ExercisePlayPhase.presenting));
    }
  }

  Future<void> _onStartRecording(
    StartRecordingEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionInProgress) return;

    final hasPermission = await _recorderService.hasPermission();
    if (!hasPermission) {
      emit(const MissionError(
        message: 'Microphone permission is required for speaking exercises.',
      ));
      return;
    }

    await _recorderService.startRecording();
    _recordingStartTime = DateTime.now();

    emit(currentState.copyWith(
      phase: ExercisePlayPhase.recording,
      isRecording: true,
    ));
  }

  Future<void> _onStopRecording(
    StopRecordingEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionInProgress) return;

    final recordingPath = await _recorderService.stopRecording();

    if (_recordingStartTime != null) {
      final speakingDuration =
          DateTime.now().difference(_recordingStartTime!);
      _totalSpeakingSeconds += speakingDuration.inSeconds;
      _recordingStartTime = null;
    }

    emit(currentState.copyWith(
      phase: ExercisePlayPhase.evaluating,
      isRecording: false,
    ));

    final exerciseResult = _evaluateExercise(
      currentState.currentExercise,
      recordingPath: recordingPath,
      attempt: currentState.currentAttempt,
    );

    emit(currentState.copyWith(
      phase: ExercisePlayPhase.showingFeedback,
      lastResult: exerciseResult,
    ));
  }

  Future<void> _onSubmitExercise(
    SubmitExerciseEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionInProgress) return;

    await _submitExerciseResult(SubmitExerciseResultParams(
      missionId: currentState.mission.id,
      exerciseIndex: currentState.exerciseIndex,
      result: event.result,
    ));

    if (currentState.currentExercise.srsTrigger) {
      _newVocabularyIds.addAll(currentState.currentExercise.vocabularyIds);
    }

    _advanceToNext(emit, currentState);
  }

  Future<void> _onSelectAnswer(
    SelectAnswerEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionInProgress) return;

    final exercise = currentState.currentExercise;
    final options = exercise.evaluationConfig.comprehensionOptions;

    if (event.optionIndex >= options.length) return;

    final isCorrect = options[event.optionIndex].isCorrect;

    final result = ExerciseResult(
      exerciseId: exercise.id,
      outcome: isCorrect ? ExerciseOutcome.success : ExerciseOutcome.retry,
      score: isCorrect ? 1.0 : 0.0,
      attemptNumber: currentState.currentAttempt,
      timeSpentSeconds: 5,
      selectedOptionIndex: event.optionIndex,
    );

    emit(currentState.copyWith(
      phase: ExercisePlayPhase.showingFeedback,
      lastResult: result,
    ));
  }

  Future<void> _onSubmitText(
    SubmitTextEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionInProgress) return;

    final exercise = currentState.currentExercise;
    final expected = exercise.evaluationConfig.expectedText ?? '';
    final submitted = event.text.trim();

    final normalized = submitted.replaceAll(RegExp(r'[\s\-]'), '');
    final normalizedExpected = expected.replaceAll(RegExp(r'[\s\-]'), '');
    final isCorrect = normalized == normalizedExpected;

    final result = ExerciseResult(
      exerciseId: exercise.id,
      outcome: isCorrect ? ExerciseOutcome.success : ExerciseOutcome.partial,
      score: isCorrect ? 1.0 : 0.5,
      attemptNumber: currentState.currentAttempt,
      timeSpentSeconds: 10,
      typedText: submitted,
    );

    emit(currentState.copyWith(
      phase: ExercisePlayPhase.showingFeedback,
      lastResult: result,
    ));
  }

  Future<void> _onNextExercise(
    NextExerciseEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionInProgress) return;

    if (currentState.lastResult != null) {
      _stateMachine!.submitResult(currentState.lastResult!);
    }

    _advanceToNext(emit, currentState);
  }

  Future<void> _onRequestHint(
    RequestHintEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionInProgress) return;

    final scaffolding = currentState.currentScaffolding;
    if (scaffolding.hintAvailable && scaffolding.hintText != null) {
      emit(currentState.copyWith(hintText: scaffolding.hintText));
    }
  }

  Future<void> _onRetryExercise(
    RetryExerciseEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionInProgress) return;

    if (currentState.canRetry) {
      emit(currentState.copyWith(
        phase: ExercisePlayPhase.presenting,
        currentAttempt: currentState.currentAttempt + 1,
        clearResult: true,
        clearHint: true,
      ));
    } else {
      _advanceToNext(emit, currentState);
    }
  }

  Future<void> _onCompleteMission(
    CompleteMissionEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionInProgress) return;

    final mission = currentState.mission;
    final totalTime = _missionStartTime != null
        ? DateTime.now().difference(_missionStartTime!).inSeconds
        : 0;

    final completionResult = await _completeMission(CompleteMissionParams(
      mission: mission,
      exerciseResults: _stateMachine!.results,
      totalSpeakingTimeSeconds: _totalSpeakingSeconds,
      totalTimeSeconds: totalTime,
      newVocabularyIds: _newVocabularyIds.toSet().toList(),
    ));

    // FIXED: Do NOT use fold() with emit — use isLeft/isRight pattern.
    if (completionResult.isLeft()) {
      final failure = completionResult.fold((l) => l, (_) => null)!;
      emit(MissionError(message: failure.message));
      return;
    }

    final missionResult = completionResult.fold((_) => null, (r) => r)!;

    final debrief = _yasminaService.getPostMissionDebrief(
      mission: mission,
      result: missionResult,
    );

    emit(MissionCompleted(
      mission: mission,
      result: missionResult,
      yasminaDebrief: debrief,
    ));
  }

  Future<void> _onDismissYasmina(
    DismissYasminaEvent event,
    Emitter<MissionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MissionInProgress) return;

    emit(currentState.copyWith(
      phase: ExercisePlayPhase.presenting,
      clearYasmina: true,
    ));
  }

  Future<void> _onPauseMission(
    PauseMissionEvent event,
    Emitter<MissionState> emit,
  ) async {
    await _audioService.pause();
    if (_recorderService.isRecording) {
      await _recorderService.cancelRecording();
    }
  }

  Future<void> _onResumeMission(
    ResumeMissionEvent event,
    Emitter<MissionState> emit,
  ) async {
    // State is already preserved — UI will re-render correctly
  }

  // ─── Private Helpers ───────────────────────────────────────

  void _emitCurrentExercise(
    Emitter<MissionState> emit,
    Mission mission,
  ) {
    final sm = _stateMachine!;
    final exercise = sm.currentExercise;
    final scaffolding = sm.getCurrentScaffolding();

    String? yasminaMsg;
    if (mission.yasminaMessages?.midMissionEncouragement != null &&
        sm.currentIndex == 4) {
      yasminaMsg = _yasminaService.getMidMissionEncouragement(
        missionMessages: mission.yasminaMessages,
        currentAverageScore: _calculateCurrentAverage(),
        exercisesCompleted: sm.currentIndex,
        totalExercises: sm.totalExercises,
      );
    }

    emit(MissionInProgress(
      mission: mission,
      currentExercise: exercise,
      exerciseIndex: sm.currentIndex,
      totalExercises: sm.totalExercises,
      phase: yasminaMsg != null
          ? ExercisePlayPhase.showingYasmina
          : ExercisePlayPhase.presenting,
      supportLevel: sm.supportLevel,
      currentScaffolding: scaffolding,
      yasminaMessage: yasminaMsg,
    ));
  }

  void _advanceToNext(
    Emitter<MissionState> emit,
    MissionInProgress currentState,
  ) {
    if (_stateMachine!.hasNext) {
      _stateMachine!.skipExercise();
      _emitCurrentExercise(emit, currentState.mission);
    } else {
      add(const CompleteMissionEvent());
    }
  }

  ExerciseResult _evaluateExercise(
    Exercise exercise, {
    String? recordingPath,
    required int attempt,
  }) {
    final config = exercise.evaluationConfig;
    final keywordsRequired = config.keywordsRequired;
    final keywordsOptional = config.keywordsOptional;

    const baseScore = 0.65;
    final score = _scoringEngine.calculateExerciseScore(
      keywordsMatchedCount: (keywordsRequired.length * baseScore).round(),
      keywordsExpectedCount: keywordsRequired.length + keywordsOptional.length,
      pronunciationScore: baseScore,
      pronunciationWeight: config.pronunciationWeight,
      completenessWeight: config.completenessWeight,
    );

    final outcome = score >= config.minimumScore
        ? ExerciseOutcome.success
        : (score >= config.minimumScore * 0.7
            ? ExerciseOutcome.partial
            : ExerciseOutcome.retry);

    return ExerciseResult(
      exerciseId: exercise.id,
      outcome: outcome,
      score: score,
      attemptNumber: attempt,
      timeSpentSeconds: 5,
      pronunciationScore: baseScore,
      completenessScore: baseScore,
      keywordsMatched: keywordsRequired.take(
        (keywordsRequired.length * baseScore).round(),
      ).toList(),
      keywordsMissed: keywordsRequired.skip(
        (keywordsRequired.length * baseScore).round(),
      ).toList(),
      recordingPath: recordingPath,
    );
  }

  double _calculateCurrentAverage() {
    final results = _stateMachine?.results ?? [];
    if (results.isEmpty) return 0.0;
    return results.fold<double>(0.0, (s, r) => s + r.score) / results.length;
  }

  @override
  Future<void> close() async {
    await _audioService.stop();
    if (_recorderService.isRecording) {
      await _recorderService.cancelRecording();
    }
    return super.close();
  }
}
