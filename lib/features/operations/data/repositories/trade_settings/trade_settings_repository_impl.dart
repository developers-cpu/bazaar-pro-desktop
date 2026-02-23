import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/trade_settings/trade_setting.dart';
import '../../../domain/repositories/trade_settings/trade_settings_repository.dart';
import '../../datasources/trade_settings/trade_settings_remote_data_source.dart';
class TradeSettingsRepositoryImpl implements TradeSettingsRepository {
  final TradeSettingsRemoteDataSource remoteDataSource;
  TradeSettingsRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<TradeSetting>>> getTradeSettings() async {
    try {
      final result = await remoteDataSource.getTradeSettings();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
  @override
  Future<Either<Failure, bool>> updateTradeSettings({
    required List<String> ids,
    TradeSetting? details,
  }) async {
    try {
      final result = await remoteDataSource.updateTradeSettings(ids: ids);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
