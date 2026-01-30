import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
abstract class Failure extends Equatable {
  final String message;
  final dynamic originalError;

  const Failure(this.message, [this.originalError]);

  @override
  List<Object?> get props => [message, originalError];
}

/// Represents a failure during data validation.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Represents a failure during local storage operations (Drift/SharedPrefs).
class StorageFailure extends Failure {
  const StorageFailure(super.message, [super.originalError]);
}

/// Represents a failure from the remote server/API.
class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.originalError]);
}

/// Represents a failure during synchronization with the server.
class SyncFailure extends Failure {
  const SyncFailure(super.message, [super.originalError]);
}

/// Represents an unknown or unexpected failure.
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.originalError]);
}
