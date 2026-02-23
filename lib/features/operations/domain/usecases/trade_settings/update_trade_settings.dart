import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/operations/domain/entities/trade_settings/trade_setting.dart';
import 'package:bazarpro/features/operations/domain/repositories/trade_settings/trade_settings_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateTradeSettings implements UseCase<bool, UpdateTradeSettingsParams> {
  final TradeSettingsRepository repository;

  UpdateTradeSettings(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateTradeSettingsParams params) async {
    return await repository.updateTradeSettings(
      ids: params.ids,
      details: params.details,
    );
  }
}

class UpdateTradeSettingsParams extends Equatable {
  final List<String> ids;
  final TradeSetting? details;

  const UpdateTradeSettingsParams({required this.ids, this.details});

  @override
  List<Object?> get props => [ids, details];
}
