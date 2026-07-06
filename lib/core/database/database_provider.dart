import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

/// Provides database instances to datasources.
///
/// This abstraction allows datasources to depend on an interface
/// rather than directly on the DatabaseService singleton. This
/// enables testing with in-memory databases.
class DatabaseProvider {
  DatabaseProvider(this._service);

  final DatabaseService _service;

  /// Get the user database (read-write).
  Database get userDb => _service.userDb;

  /// Get the content database (read-only in production).
  Database get contentDb => _service.contentDb;
}
