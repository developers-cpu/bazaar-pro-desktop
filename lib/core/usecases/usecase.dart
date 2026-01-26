import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Base class for all use cases in the application
abstract class UseCase<Type, Params> {
  /// Execute the use case with given parameters
  Future<Either<Failure, Type>> call(Params params);
}
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
