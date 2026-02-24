import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/exchange_settings/exchange_setting.dart';

abstract class ExchangeSettingsRepository {
  Future<Either<Failure, List<ExchangeSetting>>> getExchangeSettings();
  Future<Either<Failure, bool>> updateExchangeSettings({
    required List<String> ids,
  });
  Future<Either<Failure, List<DefaultSymbol>>> getDefaultSymbols({
    required String exchange,
  });
}
