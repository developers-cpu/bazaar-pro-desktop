import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/operations/domain/entities/exchange_settings/exchange_setting.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../repositories/exchange_settings/exchange_settings_repository.dart';

class GetExchangeSettings implements UseCase<List<ExchangeSetting>, NoParams> {
  final ExchangeSettingsRepository repository;

  GetExchangeSettings(this.repository);

  @override
  Future<Either<Failure, List<ExchangeSetting>>> call(NoParams params) async {
    return await repository.getExchangeSettings();
  }
}
