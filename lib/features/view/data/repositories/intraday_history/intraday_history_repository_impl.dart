import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/intraday_history/intraday_history.dart';
import '../../../domain/repositories/intraday_history/intraday_history_repository.dart';
import '../../datasources/intraday_history/intraday_history_remote_datasource.dart';
import '../../models/intraday_history/intraday_history_model.dart';
class IntradayHistoryRepositoryImpl implements IntradayHistoryRepository {
  final IntradayHistoryRemoteDataSource remoteDataSource;
  IntradayHistoryRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<IntradayHistory>>> getIntradayHistory({
    DateTime? date,
    String? exchange,
    String? symbol,
    String? timing,
  }) async {
    try {
      final history = await remoteDataSource.getIntradayHistory(
        date: date,
        exchange: exchange,
        symbol: symbol,
        timing: timing,
      );
      return Right(history);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<IntradayHistory>>> getIntradayHistoryInSeconds({
    required DateTime date,
    required String exchange,
    required String symbol,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final history = await remoteDataSource.getIntradayHistoryInSeconds(
        date: date,
        exchange: exchange,
        symbol: symbol,
        startTime: startTime,
        endTime: endTime,
      );
      return Right(history);
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
  Future<Either<Failure, List<String>>> getTimings() async {
    try {
      final timings = await remoteDataSource.getTimings();
      return Right(timings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<TimeSlot>>> getAvailableTimeSlots(
      DateTime date) async {
    try {
      final slots = await remoteDataSource.getAvailableTimeSlots(date);
      return Right(slots);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, String>> exportToPdf(
      List<IntradayHistory> history) async {
    try {
      final models =
      history.map((h) => IntradayHistoryModel.fromEntity(h)).toList();
      final path = await remoteDataSource.exportToPdf(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, String>> exportToExcel(
      List<IntradayHistory> history) async {
    try {
      final models =
      history.map((h) => IntradayHistoryModel.fromEntity(h)).toList();
      final path = await remoteDataSource.exportToExcel(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
