import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Authentication repository interface
/// Domain layer - defines contract for authentication operations
abstract class AuthRepository {
  /// Login user with username and password
  /// Returns Either<Failure, User>
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
    int expiresInMins,
  });

  /// Refresh access token
  /// Returns Either<Failure, User>
  Future<Either<Failure, User>> refreshToken({
    required String refreshToken,
  });

  /// Logout user
  /// Returns Either<Failure, bool>
  Future<Either<Failure, bool>> logout();
}