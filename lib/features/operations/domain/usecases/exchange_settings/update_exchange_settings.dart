import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/operations/domain/repositories/exchange_settings/exchange_settings_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateExchangeSettingsParams extends Equatable {
  final List<String> ids;
  const UpdateExchangeSettingsParams({required this.ids});
  @override
  List<Object?> get props => [ids];
}

class UpdateExchangeSettings
    implements UseCase<bool, UpdateExchangeSettingsParams> {
  final ExchangeSettingsRepository repository;
  UpdateExchangeSettings(this.repository);
  @override
  Future<Either<Failure, bool>> call(
    UpdateExchangeSettingsParams params,
  ) async {
    return await repository.updateExchangeSettings(ids: params.ids);
  }
}
