import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/exchange_settings/exchange_setting.dart';
import '../../entities/exchange_settings/market_timing.dart';
import '../../entities/exchange_settings/exchange_holiday.dart';
import '../../entities/exchange_settings/exchange_timing_detail.dart';

abstract class ExchangeSettingsRepository {
  Future<Either<Failure, List<ExchangeSetting>>> getExchangeSettings();
  Future<Either<Failure, bool>> updateExchangeSettings({
    required List<String> ids,
  });
  Future<Either<Failure, List<DefaultSymbol>>> getDefaultSymbols({
    required String exchange,
  });
  Future<Either<Failure, List<ExchangeMarketTiming>>> getMarketTimings();
  Future<Either<Failure, bool>> updateMarketTimingsFromExcel({
    required List<int> bytes,
  });
  Future<Either<Failure, bool>> updateMarketTimingStatus({
    required String id,
    required bool isOn,
  });
  Future<Either<Failure, List<ExchangeHoliday>>> getExchangeHolidays({
    required String exchange,
  });
  Future<Either<Failure, bool>> updateExchangeHoliday(ExchangeHoliday holiday);
  Future<Either<Failure, bool>> deleteExchangeHoliday(String id);
  Future<Either<Failure, List<ExchangeTimingDetail>>> getExchangeTimings({
    required String exchange,
  });
  Future<Either<Failure, bool>> updateExchangeTiming(
    ExchangeTimingDetail timing,
  );
  Future<Either<Failure, bool>> deleteExchangeTiming(String id);
}
