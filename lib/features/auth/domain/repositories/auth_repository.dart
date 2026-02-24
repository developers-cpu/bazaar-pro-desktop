import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
    int expiresInMins,
  });
  Future<Either<Failure, User>> refreshToken({required String refreshToken});
  Future<Either<Failure, bool>> logout();
}
