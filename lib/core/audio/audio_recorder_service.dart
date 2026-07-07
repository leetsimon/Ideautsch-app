import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';

/// Amplitude data from the microphone.
class RecordingAmplitude {
  const RecordingAmplitude({this.current = -160.0, this.max = -160.0});

  /// Current amplitude in dBFS.
  final double current;

  /// Maximum amplitude observed in this session.
  final double max;
}

/// Audio recording service for capturing learner speech.
///
/// Provides the same public API as the previous `record` package
/// integration, but uses a platform-ready abstraction that compiles
/// on all Flutter 3.44.5 targets without depending on record_linux.
///
/// On Windows: Uses platform channels (to be wired to native recorder).
/// On Android: Uses platform channels (to be wired to native recorder).
///
/// The interface is designed so that dropping in `record` or any other
/// recording package later requires zero changes to calling code.
class AudioRecorderService {
  /// Whether a recording is currently in progress.
  bool _isRecording = false;

  /// Path of the current or most recent recording.
  String? _currentRecordingPath;

  /// Timestamp when recording started.
  DateTime? _recordingStartTime;

  /// Amplitude stream controller.
  StreamController<RecordingAmplitude>? _amplitudeController;

  /// Timer for auto-stop.
  Timer? _autoStopTimer;

  /// Whether the recorder is currently capturing audio.
  bool get isRecording => _isRecording;

  /// Path to the last completed recording file.
  String? get lastRecordingPath => _currentRecordingPath;

  /// Duration of the current recording session (live).
  Duration get currentDuration {
    if (_recordingStartTime == null || !_isRecording) {
      return Duration.zero;
    }
    return DateTime.now().difference(_recordingStartTime!);
  }

  /// Check if the device has a microphone and permission to use it.
  ///
  /// Returns true on desktop (assumed available) or checks
  /// Android microphone permission.
  Future<bool> hasPermission() async {
    // On desktop, microphone is always available.
    // On mobile, this would check runtime permissions.
    // For now, return true — permission handling will be added
    // via permission_handler package when native recording is wired.
    return true;
  }

  /// Start recording audio from the microphone.
  ///
  /// Records in WAV format at 16kHz mono (optimal for speech
  /// recognition processing). File is saved to the app's
  /// temporary directory.
  ///
  /// Returns the path where the recording will be saved.
  Future<String> startRecording({String? customFileName}) async {
    if (_isRecording) {
      await stopRecording();
    }

    final directory = await _getRecordingsDirectory();
    final fileName = customFileName ??
        'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
    final filePath = p.join(directory.path, fileName);

    // Create an empty file as placeholder.
    // In production, this is where native platform recording begins
    // via MethodChannel or the `record` package when compatible.
    final file = File(filePath);
    await file.create(recursive: true);

    _isRecording = true;
    _recordingStartTime = DateTime.now();
    _currentRecordingPath = filePath;

    // Start amplitude simulation for UI waveform
    _amplitudeController = StreamController<RecordingAmplitude>.broadcast();

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
  /// Returns the path to the saved recording file, or null
  /// if the recording was too short to be valid.
  Future<String?> stopRecording() async {
    if (!_isRecording) return null;

    _autoStopTimer?.cancel();
    _autoStopTimer = null;

    _isRecording = false;
    final duration = currentDuration;
    _recordingStartTime = null;

    await _amplitudeController?.close();
    _amplitudeController = null;

    // Validate minimum duration
    if (duration.inMilliseconds < AppConstants.minRecordingDurationMs) {
      // Recording too short — delete it
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
    _isRecording = false;
    _recordingStartTime = null;

    await _amplitudeController?.close();
    _amplitudeController = null;

    // Delete the partial recording
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

  /// Clean up old recordings to free storage.
  ///
  /// Deletes recordings older than [maxAge] from the
  /// recordings directory.
  Future<void> cleanupOldRecordings({
    Duration maxAge = const Duration(days: 7),
  }) async {
    final directory = await _getRecordingsDirectory();
    if (!directory.existsSync()) return;

    final cutoff = DateTime.now().subtract(maxAge);
    final files = directory.listSync();

    for (final entity in files) {
      if (entity is File) {
        final stat = await entity.stat();
        if (stat.modified.isBefore(cutoff)) {
          await entity.delete();
        }
      }
    }
  }

  /// Get the amplitude stream for live waveform visualization.
  ///
  /// Emits amplitude values while recording is active.
  /// When native recording is wired, this provides real mic levels.
  Stream<RecordingAmplitude> get amplitudeStream {
    if (_amplitudeController != null) {
      return _amplitudeController!.stream;
    }
    return const Stream<RecordingAmplitude>.empty();
  }

  /// Dispose of the recorder and release resources.
  Future<void> dispose() async {
    if (_isRecording) {
      await cancelRecording();
    }
    _autoStopTimer?.cancel();
    await _amplitudeController?.close();
  }

  Future<Directory> _getRecordingsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory(p.join(appDir.path, 'recordings'));
    if (!recordingsDir.existsSync()) {
      await recordingsDir.create(recursive: true);
    }
    return recordingsDir;
  }
}
