import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Base class for all use cases in the application
/// Type represents the return type of the use case
/// Params represents the parameters required by the use case
/// Returns Either<Failure, Type> for error handling
abstract class UseCase<Type, Params> {
  /// Execute the use case with given parameters
  /// Returns Either Left for failure or Right for success
  Future<Either<Failure, Type>> call(Params params);
}

/// Class to represent no parameters for use cases that don't require any
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
