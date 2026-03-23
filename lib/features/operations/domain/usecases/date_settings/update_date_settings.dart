import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/operations/domain/entities/date_settings/date_setting.dart';
import 'package:bazarpro/features/operations/domain/repositories/date_settings/date_settings_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateDateSettings implements UseCase<bool, UpdateDateSettingsParams> {
  final DateSettingsRepository repository;
  UpdateDateSettings(this.repository);
  @override
  Future<Either<Failure, bool>> call(UpdateDateSettingsParams params) async {
    return await repository.updateDateSettings(
      ids: params.ids,
      details: params.details,
    );
  }
}

class UpdateDateSettingsParams extends Equatable {
  final List<String> ids;
  final DateSetting? details;
  const UpdateDateSettingsParams({required this.ids, this.details});
  @override
  List<Object?> get props => [ids, details];
}
