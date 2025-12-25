import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Implementation of AuthRepository
/// Bridges data sources and domain layer
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
    int expiresInMins = 30,
  }) async {
    try {
      final user = await remoteDataSource.login(
        username: username,
        password: password,
        expiresInMins: expiresInMins,
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final user = await remoteDataSource.refreshToken(
        refreshToken: refreshToken,
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      // Since the API doesn't have a logout endpoint,
      // we'll just return success
      // In a real app, you'd clear local storage here
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}