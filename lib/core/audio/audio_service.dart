import 'package:just_audio/just_audio.dart';

/// Audio playback service for the application.
///
/// Manages playback of:
/// - Native-speed vocabulary and dialogue audio
/// - Slow-speed learning audio
/// - Shadow-speed audio (90% for shadowing exercises)
/// - UI sounds (session start, exercise complete)
///
/// Supports variable playback speed and preloading
/// for zero-latency exercise transitions.
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

  /// Play an audio asset from the app bundle.
  ///
  /// [assetPath] is relative to the assets directory
  /// (e.g., "audio/missions/m01_001_d/vocab_guten_tag_native.opus").
  ///
  /// [speed] controls playback rate (1.0 = normal, 0.75 = slow).
  Future<void> playAsset(String assetPath, {double speed = 1.0}) async {
    await _player.setSpeed(speed);
    await _player.setAsset('assets/$assetPath');
    await _player.play();
  }

  /// Play an audio file from the device file system.
  ///
  /// Used for playing back learner recordings.
  Future<void> playFile(String filePath, {double speed = 1.0}) async {
    await _player.setSpeed(speed);
    await _player.setFilePath(filePath);
    await _player.play();
  }

  /// Preload an asset without playing it.
  ///
  /// Used to eliminate latency before exercises that need
  /// immediate audio response (shadow, listen exercises).
  Future<Duration?> preloadAsset(String assetPath) async {
    return _player.setAsset('assets/$assetPath');
  }

  /// Pause playback (can be resumed).
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback after pause.
  Future<void> resume() async {
    await _player.play();
  }

  /// Stop playback and reset position.
  Future<void> stop() async {
    await _player.stop();
  }

  /// Seek to a specific position in the audio.
  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  /// Set playback speed without starting playback.
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  /// Wait for the current audio to finish playing.
  ///
  /// Returns when playback completes naturally (not stopped).
  /// Useful for sequential audio playback in exercises.
  Future<void> waitForCompletion() async {
    await _player.playerStateStream.firstWhere(
      (state) => state.processingState == ProcessingState.completed,
    );
  }

  /// Dispose of the audio player and release resources.
  ///
  /// Call this when the service is no longer needed
  /// (app shutdown or service replacement).
  Future<void> dispose() async {
    await _player.dispose();
  }
}
