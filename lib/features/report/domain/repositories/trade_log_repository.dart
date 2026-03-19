import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/trade_log.dart';

abstract class TradeLogRepository {
  Future<Either<Failure, List<TradeLog>>> getTradeLogs({
    String? dateRange,
    String? user,
    String? exchange,
    String? symbol,
  });
}