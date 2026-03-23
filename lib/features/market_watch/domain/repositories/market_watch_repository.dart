import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/market_item.dart';

abstract class MarketWatchRepository {
  Future<Either<Failure, List<MarketItem>>> getMarketItems();
  Future<Either<Failure, List<MarketItem>>> getMarketItemsByExchange(
    String exchange,
  );
  Future<Either<Failure, List<MarketItem>>> getMarketItemsBySymbol(
    String symbol,
  );
  Future<Either<Failure, MarketItem>> addMarketItem(MarketItem item);
  Future<Either<Failure, bool>> deleteMarketItem(String id);
  Future<Either<Failure, MarketItem>> updateMarketItem(MarketItem item);
}
