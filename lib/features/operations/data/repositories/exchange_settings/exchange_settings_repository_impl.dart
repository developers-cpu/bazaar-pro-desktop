import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/exchange_settings/exchange_setting.dart';
import '../../../domain/repositories/exchange_settings/exchange_settings_repository.dart';
import '../../datasources/exchange_settings/exchange_settings_remote_data_source.dart';

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
}
