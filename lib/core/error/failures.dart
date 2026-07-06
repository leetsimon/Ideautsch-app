import 'package:equatable/equatable.dart';

/// Base failure class for the Either pattern.
///
/// All failures extend this class and provide a user-friendly message.
/// Failures represent expected error conditions that the application
/// handles gracefully (unlike exceptions, which are unexpected).
abstract class Failure extends Equatable {
  const Failure({required this.message});

  /// Human-readable description of what went wrong.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failure when a database operation fails.
class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}

/// Failure when requested content is not found.
class ContentNotFoundFailure extends Failure {
  const ContentNotFoundFailure({required super.message});
}

/// Failure when audio playback or recording fails.
class AudioFailure extends Failure {
  const AudioFailure({required super.message});
}

/// Failure when file system operations fail.
class StorageFailure extends Failure {
  const StorageFailure({required super.message});
}

/// Failure when required permissions are not granted.
class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

/// Generic unexpected failure (last resort).
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}
