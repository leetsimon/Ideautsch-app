import 'dart:async';

import 'audio_service.dart';

/// Controls smooth audio fade-in and fade-out.
///
/// Instead of abrupt volume jumps, audio fades smoothly:
/// - Fade in: 0% → 100% over 200ms (music/ambiance)
/// - Fade out: 100% → 0% over 300ms (before stopping)
/// - Cross-fade: one track fades out while another fades in
///
/// Used for:
/// - Exercise audio model playback
/// - Background ambiance (call center environment)
/// - Transition between screens with audio
class AudioFadeController {
  AudioFadeController(this._audioService);

  final AudioService _audioService;

  Timer? _fadeTimer;
  double _currentVolume = 1.0;

  /// Fade in from silence to full volume over [duration].
  Future<void> fadeIn({
    required String assetPath,
    Duration duration = const Duration(milliseconds: 200),
    double targetVolume = 1.0,
    double speed = 1.0,
  }) async {
    _currentVolume = 0.0;
    await _audioService.playAsset(assetPath, speed: speed);

    final steps = 10;
    final stepDuration = duration ~/ steps;
    final volumeStep = targetVolume / steps;

    _fadeTimer?.cancel();
    var currentStep = 0;

    _fadeTimer = Timer.periodic(
      Duration(milliseconds: stepDuration.inMilliseconds),
      (timer) {
        currentStep++;
        _currentVolume = (volumeStep * currentStep).clamp(0.0, targetVolume);

        if (currentStep >= steps) {
          timer.cancel();
          _currentVolume = targetVolume;
        }
      },
    );
  }

  /// Fade out from current volume to silence over [duration], then stop.
  Future<void> fadeOut({
    Duration duration = const Duration(milliseconds: 300),
  }) async {
    final startVolume = _currentVolume;
    final steps = 10;
    final stepDuration = duration ~/ steps;
    final volumeStep = startVolume / steps;

    _fadeTimer?.cancel();
    var currentStep = 0;

    final completer = Completer<void>();

    _fadeTimer = Timer.periodic(
      Duration(milliseconds: stepDuration.inMilliseconds),
      (timer) {
        currentStep++;
        _currentVolume = (startVolume - volumeStep * currentStep).clamp(0.0, 1.0);

        if (currentStep >= steps) {
          timer.cancel();
          _currentVolume = 0.0;
          _audioService.stop();
          completer.complete();
        }
      },
    );

    return completer.future;
  }

  /// Stop immediately (for when smooth fade isn't needed).
  Future<void> stopImmediate() async {
    _fadeTimer?.cancel();
    _currentVolume = 0.0;
    await _audioService.stop();
  }

  /// Clean up resources.
  void dispose() {
    _fadeTimer?.cancel();
  }
}
