import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../constants/app_constants.dart';

/// Audio recording service for capturing learner speech.
///
/// Manages:
/// - Microphone recording with configurable parameters
/// - Recording duration tracking
/// - File storage in app-private directory
/// - Recording cleanup (temp file management)
///
/// Designed for offline operation — no cloud processing.
/// Recordings are evaluated locally via the speech evaluation pipeline.
class AudioRecorderService {
  AudioRecorderService() : _recorder = AudioRecorder();

  final AudioRecorder _recorder;

  /// Whether a recording is currently in progress.
  bool _isRecording = false;

  /// Path of the current or most recent recording.
  String? _currentRecordingPath;

  /// Timestamp when recording started.
  DateTime? _recordingStartTime;

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
  Future<bool> hasPermission() async {
    return _recorder.hasPermission();
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

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
        bitRate: 256000,
      ),
      path: filePath,
    );

    _isRecording = true;
    _recordingStartTime = DateTime.now();
    _currentRecordingPath = filePath;

    // Auto-stop after maximum duration
    Future.delayed(
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

    final path = await _recorder.stop();
    _isRecording = false;

    final duration = currentDuration;
    _recordingStartTime = null;

    // Validate minimum duration
    if (duration.inMilliseconds < AppConstants.minRecordingDurationMs) {
      // Recording too short — delete it
      if (path != null) {
        final file = File(path);
        if (file.existsSync()) {
          await file.delete();
        }
      }
      _currentRecordingPath = null;
      return null;
    }

    _currentRecordingPath = path;
    return path;
  }

  /// Cancel an in-progress recording without saving.
  Future<void> cancelRecording() async {
    if (!_isRecording) return;

    final path = await _recorder.stop();
    _isRecording = false;
    _recordingStartTime = null;

    // Delete the partial recording
    if (path != null) {
      final file = File(path);
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
  Stream<Amplitude> get amplitudeStream =>
      _recorder.onAmplitudeChanged(const Duration(milliseconds: 100));

  /// Dispose of the recorder and release resources.
  Future<void> dispose() async {
    if (_isRecording) {
      await cancelRecording();
    }
    await _recorder.dispose();
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
