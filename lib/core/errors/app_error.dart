import 'package:equatable/equatable.dart';

class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class CacheException extends AppException {
  CacheException(super.message);
}

class ServerException extends AppException {
  ServerException(super.message);
}

class ValidationException extends AppException {
  ValidationException(super.message);
}

class NoDataException extends AppException {
  NoDataException(super.message);
}

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NoDataFailure extends Failure {
  const NoDataFailure([super.message = 'No data available']);
}

class UndoRedoFailure extends Failure {
  const UndoRedoFailure(super.message);
}

class ExportFailure extends Failure {
  const ExportFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
