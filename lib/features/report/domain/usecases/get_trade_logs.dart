import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trade_log.dart';
import '../repositories/trade_log_repository.dart';
class GetTradeLogsUseCase {
  final TradeLogRepository repository;
  GetTradeLogsUseCase({required this.repository});
  Future<Either<Failure, List<TradeLog>>> call({
    String? dateRange,
    String? user,
    String? exchange,
    String? symbol,
  }) async {
    return await repository.getTradeLogs(
      dateRange: dateRange,
      user: user,
      exchange: exchange,
      symbol: symbol,
    );
  }
}
