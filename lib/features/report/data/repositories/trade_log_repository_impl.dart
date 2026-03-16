import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/trade_log.dart';
import '../../domain/repositories/trade_log_repository.dart';
import '../datasources/trade_log/trade_log_remote_datasource.dart';

class TradeLogRepositoryImpl implements TradeLogRepository {
  final TradeLogRemoteDataSource remoteDataSource;
  TradeLogRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<TradeLog>>> getTradeLogs({
    String? dateRange,
    String? user,
    String? exchange,
    String? symbol,
  }) async {
    try {
      final result = await remoteDataSource.getTradeLogs(
        dateRange: dateRange,
        user: user,
        exchange: exchange,
        symbol: symbol,
      );
      return result.map((models) => models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
