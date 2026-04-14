import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/exchange_settings/exchange_setting.dart';
import '../../../domain/entities/exchange_settings/market_timing.dart';
import '../../../domain/entities/exchange_settings/exchange_holiday.dart';
import '../../../domain/entities/exchange_settings/exchange_timing_detail.dart';
import '../../../domain/repositories/exchange_settings/exchange_settings_repository.dart';
import '../../datasources/exchange_settings/exchange_settings_remote_data_source.dart';
import '../../models/exchange_settings/exchange_holiday_model.dart';
import '../../models/exchange_settings/exchange_timing_model.dart';

class ExchangeSettingsRepositoryImpl implements ExchangeSettingsRepository {
  final ExchangeSettingsRemoteDataSource remoteDataSource;
  ExchangeSettingsRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<ExchangeSetting>>> getExchangeSettings() async {
    try {
      final result = await remoteDataSource.getExchangeSettings();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateExchangeSettings({
    required List<String> ids,
  }) async {
    try {
      final result = await remoteDataSource.updateExchangeSettings(ids: ids);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<DefaultSymbol>>> getDefaultSymbols({
    required String exchange,
  }) async {
    try {
      final result = await remoteDataSource.getDefaultSymbols(
        exchange: exchange,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExchangeMarketTiming>>> getMarketTimings() async {
    try {
      final result = await remoteDataSource.getMarketTimings();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateMarketTimingsFromExcel({
    required List<int> bytes,
  }) async {
    try {
      final result = await remoteDataSource.updateMarketTimingsFromExcel(
        bytes: bytes,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateMarketTimingStatus({
    required String id,
    required bool isOn,
  }) async {
    try {
      final result = await remoteDataSource.updateMarketTimingStatus(
        id: id,
        isOn: isOn,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExchangeHoliday>>> getExchangeHolidays({
    required String exchange,
  }) async {
    try {
      final result = await remoteDataSource.getExchangeHolidays(
        exchange: exchange,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateExchangeHoliday(
    ExchangeHoliday holiday,
  ) async {
    try {
      final result = await remoteDataSource.updateExchangeHoliday(
        ExchangeHolidayModel(
          id: holiday.id,
          date: holiday.date,
          remark: holiday.remark,
          exchange: holiday.exchange,
        ),
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteExchangeHoliday(String id) async {
    try {
      final result = await remoteDataSource.deleteExchangeHoliday(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExchangeTimingDetail>>> getExchangeTimings({
    required String exchange,
  }) async {
    try {
      final result = await remoteDataSource.getExchangeTimings(
        exchange: exchange,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateExchangeTiming(
    ExchangeTimingDetail timing,
  ) async {
    try {
      final result = await remoteDataSource.updateExchangeTiming(
        ExchangeTimingModel(
          id: timing.id,
          days: timing.days,
          startTime: timing.startTime,
          endTime: timing.endTime,
          remark: timing.remark,
          exchange: timing.exchange,
        ),
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteExchangeTiming(String id) async {
    try {
      final result = await remoteDataSource.deleteExchangeTiming(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
