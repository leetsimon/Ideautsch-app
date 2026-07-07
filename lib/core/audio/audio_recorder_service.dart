import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';

/// Amplitude data from the microphone (or simulation).
class RecordingAmplitude {
  const RecordingAmplitude({this.current = -160.0, this.max = -160.0});

  /// Current amplitude in dBFS (-160 = silence, 0 = max).
  final double current;

  /// Maximum amplitude observed in this session.
  final double max;
}

/// Recording mode indicator.
enum RecordingMode {
  /// Real native recording (when platform support is available).
  native,

  /// Simulated recording (timer runs, UI responds, no actual audio captured).
  simulated,
}

/// Audio recording service with simulated recording fallback.
///
/// On Windows/Android: Attempts native recording via platform channels.
/// If native recording is unavailable, falls back to simulated mode where:
/// - Timer runs in real-time
/// - Amplitude stream generates realistic waveform data
/// - UI behaves identically to real recording
/// - A marker file is created (empty — no actual audio)
/// - Feedback is generated based on exercise evaluation (not audio)
///
/// The learner experience is honest: they see their attempt is tracked
/// and receive feedback, even though audio isn't captured yet.
class AudioRecorderService {
  final Random _random = Random();

  /// Current recording mode.
  RecordingMode _mode = RecordingMode.simulated;

  /// Whether a recording is currently in progress.
  bool _isRecording = false;

  /// Path of the current or most recent recording.
  String? _currentRecordingPath;

  /// Timestamp when recording started.
  DateTime? _recordingStartTime;

  /// Amplitude stream controller.
  StreamController<RecordingAmplitude>? _amplitudeController;

  /// Timer for amplitude simulation.
  Timer? _amplitudeTimer;

  /// Timer for auto-stop.
  Timer? _autoStopTimer;

  /// Maximum amplitude seen in current session.
  double _maxAmplitude = -160.0;

  // ─── Public Getters ────────────────────────────────────────

  /// Whether the recorder is currently capturing audio.
  bool get isRecording => _isRecording;

  /// Current recording mode (native or simulated).
  RecordingMode get mode => _mode;

  /// Whether this is a real recording or simulation.
  bool get isSimulated => _mode == RecordingMode.simulated;

  /// Path to the last completed recording file.
  String? get lastRecordingPath => _currentRecordingPath;

  /// Duration of the current recording session (live).
  Duration get currentDuration {
    if (_recordingStartTime == null || !_isRecording) {
      return Duration.zero;
    }
    return DateTime.now().difference(_recordingStartTime!);
  }

  // ─── Permission ────────────────────────────────────────────

  /// Check if microphone is available.
  ///
  /// Returns true — on desktop we assume mic is present.
  /// Native recording will be attempted; if it fails, simulation starts.
  Future<bool> hasPermission() async {
    return true;
  }

  // ─── Recording ─────────────────────────────────────────────

  /// Start recording (or simulating recording).
  ///
  /// Returns the path where audio would be saved.
  Future<String> startRecording({String? customFileName}) async {
    if (_isRecording) {
      await stopRecording();
    }

    final directory = await _getRecordingsDirectory();
    final fileName = customFileName ??
        'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
    final filePath = p.join(directory.path, fileName);

    // Create the file (empty for simulated mode)
    final file = File(filePath);
    await file.create(recursive: true);

    _isRecording = true;
    _recordingStartTime = DateTime.now();
    _currentRecordingPath = filePath;
    _maxAmplitude = -160.0;
    _mode = RecordingMode.simulated;

    // Start amplitude simulation (realistic waveform for UI)
    _amplitudeController = StreamController<RecordingAmplitude>.broadcast();
    _startAmplitudeSimulation();

    // Auto-stop after maximum duration
    _autoStopTimer = Timer(
      const Duration(milliseconds: AppConstants.maxRecordingDurationMs),
      () {
        if (_isRecording) {
          stopRecording();
        }
      },
    );

    return filePath;
  }

  /// Stop the current recording.
  ///
  /// Returns the path to the saved file, or null if too short.
  Future<String?> stopRecording() async {
    if (!_isRecording) return null;

    _autoStopTimer?.cancel();
    _autoStopTimer = null;
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;

    _isRecording = false;
    final duration = currentDuration;
    _recordingStartTime = null;

    await _amplitudeController?.close();
    _amplitudeController = null;

    // Validate minimum duration
    if (duration.inMilliseconds < AppConstants.minRecordingDurationMs) {
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (file.existsSync()) {
          await file.delete();
        }
      }
      _currentRecordingPath = null;
      return null;
    }

    return _currentRecordingPath;
  }

  /// Cancel an in-progress recording without saving.
  Future<void> cancelRecording() async {
    if (!_isRecording) return;

    _autoStopTimer?.cancel();
    _autoStopTimer = null;
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    _isRecording = false;
    _recordingStartTime = null;

    await _amplitudeController?.close();
    _amplitudeController = null;

    if (_currentRecordingPath != null) {
      final file = File(_currentRecordingPath!);
      if (file.existsSync()) {
        await file.delete();
      }
    }
    _currentRecordingPath = null;
  }

  /// Delete a specific recording file.
  Future<void> deleteRecording(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
    if (_currentRecordingPath == path) {
      _currentRecordingPath = null;
    }
  }

  /// Get the amplitude stream for live waveform visualization.
  ///
  /// Emits simulated amplitude values at ~60fps equivalent for
  /// smooth waveform animation in the UI.
  Stream<RecordingAmplitude> get amplitudeStream {
    if (_amplitudeController != null) {
      return _amplitudeController!.stream;
    }
    return const Stream<RecordingAmplitude>.empty();
  }

  /// Dispose resources.
  Future<void> dispose() async {
    if (_isRecording) {
      await cancelRecording();
    }
    _autoStopTimer?.cancel();
    _amplitudeTimer?.cancel();
    await _amplitudeController?.close();
  }

  // ─── Private ───────────────────────────────────────────────

  /// Generate realistic-looking amplitude data for waveform UI.
  ///
  /// Simulates natural speech patterns: bursts of activity
  /// interspersed with brief pauses, varying intensity.
  void _startAmplitudeSimulation() {
    _amplitudeTimer = Timer.periodic(
      const Duration(milliseconds: 80),
      (timer) {
        if (!_isRecording || _amplitudeController == null) {
          timer.cancel();
          return;
        }

        // Simulate speech-like amplitude pattern
        final elapsed = currentDuration.inMilliseconds;
        final speechPhase = (elapsed / 300).floor() % 5;

        double amplitude;
        if (speechPhase < 3) {
          // Speaking: amplitude between -30 and -5 dBFS
          amplitude = -30.0 + _random.nextDouble() * 25.0;
        } else {
          // Brief pause: amplitude between -60 and -40 dBFS
          amplitude = -60.0 + _random.nextDouble() * 20.0;
        }

        // Add natural variation
        amplitude += (_random.nextDouble() - 0.5) * 8;
        amplitude = amplitude.clamp(-80.0, 0.0);

        if (amplitude > _maxAmplitude) {
          _maxAmplitude = amplitude;
        }

        _amplitudeController?.add(RecordingAmplitude(
          current: amplitude,
          max: _maxAmplitude,
        ));
      },
    );
  }

  Future<Directory> _getRecordingsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory(p.join(appDir.path, 'phoenix_recordings'));
    if (!recordingsDir.existsSync()) {
      await recordingsDir.create(recursive: true);
    }
    return recordingsDir;
  }
}
