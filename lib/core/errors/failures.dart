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
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

/// Failure when server operations fail
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

/// Failure when network is unavailable
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection']) : super(message);
}

/// Failure when validation fails
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// Failure when no data is available
class NoDataFailure extends Failure {
  const NoDataFailure([String message = 'No data available']) : super(message);
}

/// Failure when undo/redo operations fail
class UndoRedoFailure extends Failure {
  const UndoRedoFailure(String message) : super(message);
}

/// Failure when PDF/Excel export fails
class ExportFailure extends Failure {
  const ExportFailure(String message) : super(message);
}

/// Failure for unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'An unexpected error occurred']) : super(message);
}