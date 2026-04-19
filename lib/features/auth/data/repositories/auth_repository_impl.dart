import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

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
      await localDataSource.saveSession(user);
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
      await localDataSource.saveSession(user);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await localDataSource.clearSession();
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
