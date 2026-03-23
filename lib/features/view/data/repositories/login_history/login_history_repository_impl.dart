import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/login_history/login_history.dart';
import '../../../domain/repositories/login_history/login_history_repository.dart';
import '../../datasources/login_history/login_history_remote_datasource.dart';
import '../../models/login_history/login_history_model.dart';

class LoginHistoryRepositoryImpl implements LoginHistoryRepository {
  final LoginHistoryRemoteDataSource remoteDataSource;
  LoginHistoryRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<LoginHistory>>> getLoginHistory(
    String client, {
    String? userType,
  }) async {
    try {
      final history = await remoteDataSource.getLoginHistory(
        client,
        userType: userType,
      );
      return Right(history);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getClients() async {
    try {
      final clients = await remoteDataSource.getClients();
      return Right(clients);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToPdf(
    List<LoginHistory> history,
  ) async {
    try {
      final models = history
          .map((h) => LoginHistoryModel.fromEntity(h))
          .toList();
      final path = await remoteDataSource.exportToPdf(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToExcel(
    List<LoginHistory> history,
  ) async {
    try {
      final models = history
          .map((h) => LoginHistoryModel.fromEntity(h))
          .toList();
      final path = await remoteDataSource.exportToExcel(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
