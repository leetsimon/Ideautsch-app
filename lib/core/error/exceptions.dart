/// Base exception for the data layer.
///
/// Exceptions are thrown by data sources and caught by repository
/// implementations, which then return appropriate [Failure] types.
/// Exceptions should never reach the presentation layer.
abstract class AppException implements Exception {
  const AppException({required this.message});

  /// Description of what went wrong at the technical level.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a database query fails or returns unexpected results.
class DatabaseException extends AppException {
  const DatabaseException({required super.message});
}

/// Thrown when requested content does not exist in the database.
class ContentNotFoundException extends AppException {
  const ContentNotFoundException({required super.message});
}

/// Thrown when audio operations (play, record, encode) fail.
class AudioException extends AppException {
  const AudioException({required super.message});
}

/// Thrown when file system operations fail.
class StorageException extends AppException {
  const StorageException({required super.message});
}
