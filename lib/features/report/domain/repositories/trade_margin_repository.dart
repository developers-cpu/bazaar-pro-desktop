import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/trade_margin.dart';

abstract class TradeMarginRepository {
  Future<Either<Failure, List<TradeMargin>>> getTradeMargins({
    String? exchange,
    String? search,
  });
}
