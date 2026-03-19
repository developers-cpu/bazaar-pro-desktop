import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/rejection_log/rejection_log.dart';
import '../../../domain/repositories/rejection_log/rejection_log_repository.dart';
import '../../datasources/rejection_log/rejection_log_remote_datasource.dart';
import '../../models/rejection_log/rejection_log_model.dart';

class RejectionLogRepositoryImpl implements RejectionLogRepository {
  final RejectionLogRemoteDataSource remoteDataSource;
  RejectionLogRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<RejectionLog>>> getRejectionLogs() async {
    try {
      final logs = await remoteDataSource.getRejectionLogs();
      return Right(logs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RejectionLog>>> getRejectionLogsWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
  }) async {
    try {
      final logs = await remoteDataSource.getRejectionLogsWithFilters(
        startDate: startDate,
        endDate: endDate,
        client: client,
        exchange: exchange,
        symbol: symbol,
      );
      return Right(logs);
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
  Future<Either<Failure, List<String>>> getExchanges() async {
    try {
      final exchanges = await remoteDataSource.getExchanges();
      return Right(exchanges);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSymbols() async {
    try {
      final symbols = await remoteDataSource.getSymbols();
      return Right(symbols);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToPdf(List<RejectionLog> logs) async {
    try {
      final models = logs.map((l) => RejectionLogModel.fromEntity(l)).toList();
      final path = await remoteDataSource.exportToPdf(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToExcel(List<RejectionLog> logs) async {
    try {
      final models = logs.map((l) => RejectionLogModel.fromEntity(l)).toList();
      final path = await remoteDataSource.exportToExcel(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}