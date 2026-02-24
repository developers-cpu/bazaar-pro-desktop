import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import 'package:bazarpro/features/operations/domain/entities/trade_settings/trade_setting.dart';

abstract class TradeSettingsRepository {
  Future<Either<Failure, List<TradeSetting>>> getTradeSettings();
  Future<Either<Failure, bool>> updateTradeSettings({
    required List<String> ids,
    TradeSetting? details,
  });
}
