/// Route path constants for the application.
///
/// Centralizing route paths prevents typos and enables
/// easy refactoring. All paths are defined as static constants.
abstract final class RouteNames {
  /// Application shell / home screen.
  static const String home = '/';

  /// Mission briefing screen.
  static const String missionBriefing = '/mission/:missionId/briefing';

  /// Active mission player screen.
  static const String missionPlayer = '/mission/:missionId/play';

  /// Mission completion summary screen.
  static const String missionSummary = '/mission/:missionId/summary';
}
