import 'dart:async';

import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

/// Audio playback service for the application.
///
/// Manages playback of vocabulary, dialogue, and UI audio.
/// Gracefully handles missing assets by reporting availability
/// rather than throwing silent exceptions.
class AudioService {
  AudioService() : _player = AudioPlayer();

  final AudioPlayer _player;

  /// Whether audio is currently playing.
  bool get isPlaying => _player.playing;

  /// Current playback position.
  Duration get position => _player.position;

  /// Total duration of the loaded audio.
  Duration? get duration => _player.duration;

  /// Stream of playback state changes.
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// Stream of playback position updates.
  Stream<Duration> get positionStream => _player.positionStream;

  /// Whether the last playback attempt succeeded.
  bool _lastPlaybackSucceeded = false;

  /// Whether the last asset existed and was playable.
  bool get lastPlaybackSucceeded => _lastPlaybackSucceeded;

  /// Check if an audio asset exists in the bundle.
  ///
  /// Returns true only for actual audio files (not placeholders).
  Future<bool> isAssetAvailable(String assetPath) async {
    try {
      // Try to load the asset data — if it fails, asset doesn't exist
      final fullPath = 'assets/$assetPath';
      await rootBundle.load(fullPath);
      // Check it's not our placeholder.json
      if (assetPath.endsWith('.json')) return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Play an audio asset from the app bundle.
  ///
  /// Returns true if playback started successfully, false if
  /// the asset is unavailable. Never throws.
  Future<bool> playAsset(String assetPath, {double speed = 1.0}) async {
    try {
      await _player.setSpeed(speed);
      await _player.setAsset('assets/$assetPath');
      await _player.play();
      _lastPlaybackSucceeded = true;
      return true;
    } catch (_) {
      _lastPlaybackSucceeded = false;
      return false;
    }
  }

  /// Play an audio file from the device file system.
  ///
  /// Returns true if playback started, false on failure.
  Future<bool> playFile(String filePath, {double speed = 1.0}) async {
    try {
      await _player.setSpeed(speed);
      await _player.setFilePath(filePath);
      await _player.play();
      _lastPlaybackSucceeded = true;
      return true;
    } catch (_) {
      _lastPlaybackSucceeded = false;
      return false;
    }
  }

  /// Wait for the current audio to finish playing.
  ///
  /// Returns immediately if nothing is playing or if playback failed.
  Future<void> waitForCompletion() async {
    if (!_lastPlaybackSucceeded) return;
    try {
      await _player.playerStateStream
          .firstWhere(
            (state) => state.processingState == ProcessingState.completed,
          )
          .timeout(const Duration(seconds: 30));
    } catch (_) {
      // Timeout or stream error — just continue
    }
  }

  /// Pause playback (can be resumed).
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (_) {}
  }

  /// Resume playback after pause.
  Future<void> resume() async {
    try {
      await _player.play();
    } catch (_) {}
  }

  /// Stop playback and reset position.
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
  }

  /// Dispose of the audio player and release resources.
  Future<void> dispose() async {
    try {
      await _player.dispose();
    } catch (_) {}
  }
}
