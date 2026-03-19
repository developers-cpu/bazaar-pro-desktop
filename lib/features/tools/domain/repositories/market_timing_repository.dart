import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/market_timing_entity.dart';

abstract class MarketTimingRepository {
  Future<Either<Failure, MarketTimingEntity>> getMarketTiming(
    String exchange,
    DateTime date,
  );
}