import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/exchange_settings/market_timing.dart';
import '../../repositories/exchange_settings/exchange_settings_repository.dart';

class GetMarketTimings implements UseCase<List<ExchangeMarketTiming>, NoParams> {
  final ExchangeSettingsRepository repository;

  GetMarketTimings(this.repository);

  @override
  Future<Either<Failure, List<ExchangeMarketTiming>>> call(NoParams params) async {
    return await repository.getMarketTimings();
  }
}
