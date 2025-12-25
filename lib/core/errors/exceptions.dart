/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;
  
  AppException(this.message);
  
  @override
  String toString() => message;
}

/// Exception thrown when cache operations fail
class CacheException extends AppException {
  CacheException(String message) : super(message);
}

/// Exception thrown when server operations fail
class ServerException extends AppException {
  ServerException(String message) : super(message);
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  ValidationException(String message) : super(message);
}

/// Exception thrown when no data is found
class NoDataException extends AppException {
  NoDataException(String message) : super(message);
}
