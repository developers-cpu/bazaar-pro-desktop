import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Uses Equatable for value comparison
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Failure when cache operations fail
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

/// Failure when server operations fail
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

/// Failure when validation fails
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// Failure when no data is available
class NoDataFailure extends Failure {
  const NoDataFailure(String message) : super(message);
}

/// Failure when undo/redo operations fail
class UndoRedoFailure extends Failure {
  const UndoRedoFailure(String message) : super(message);
}
