import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// A type alias for a Future that returns either a [Failure] or a [T] result.
/// This is the standard return type for all UseCases.
typedef Result<T> = Future<Either<Failure, T>>;

/// A type alias for a synchronous result (useful for simple validations).
typedef SyncResult<T> = Either<Failure, T>;
