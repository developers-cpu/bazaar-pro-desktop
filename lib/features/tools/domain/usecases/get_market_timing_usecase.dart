import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/market_timing_entity.dart';
import '../repositories/market_timing_repository.dart';

class GetMarketTimingUseCase
    implements UseCase<MarketTimingEntity, GetMarketTimingParams> {
  final MarketTimingRepository repository;
  GetMarketTimingUseCase(this.repository);
  @override
  Future<Either<Failure, MarketTimingEntity>> call(
    GetMarketTimingParams params,
  ) async {
    return await repository.getMarketTiming(params.exchange, params.date);
  }
}

class GetMarketTimingParams {
  final String exchange;
  final DateTime date;
  GetMarketTimingParams({required this.exchange, required this.date});
}
