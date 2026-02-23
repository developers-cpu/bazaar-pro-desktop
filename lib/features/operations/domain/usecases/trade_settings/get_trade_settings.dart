import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/operations/domain/entities/trade_settings/trade_setting.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../repositories/trade_settings/trade_settings_repository.dart';
class GetTradeSettings implements UseCase<List<TradeSetting>, NoParams> {
  final TradeSettingsRepository repository;
  GetTradeSettings(this.repository);
  @override
  Future<Either<Failure, List<TradeSetting>>> call(NoParams params) async {
    return await repository.getTradeSettings();
  }
}
