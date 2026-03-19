import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/trade_margin/trade_margin.dart';
import '../../repositories/trade_margin/trade_margin_repository.dart';

class GetTradeMarginsUseCase {
  final TradeMarginRepository repository;
  GetTradeMarginsUseCase({required this.repository});
  Future<Either<Failure, List<TradeMargin>>> call({
    String? exchange,
    String? search,
  }) async {
    return await repository.getTradeMargins(exchange: exchange, search: search);
  }
}