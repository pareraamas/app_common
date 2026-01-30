import 'package:equatable/equatable.dart';
import '../types/result.dart';

/// Base interface for all UseCases in the application.
/// 
/// [Type] is the return type of the use case.
/// [Params] is the parameter type required to execute the use case.
abstract class UseCase<Type, Params> {
  /// Executes the use case logic.
  Result<Type> call(Params params);
}

/// Helper class for UseCases that don't require any parameters.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
