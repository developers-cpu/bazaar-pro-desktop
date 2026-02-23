import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/operations/domain/entities/date_settings/date_setting.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../repositories/date_settings/date_settings_repository.dart';
class GetDateSettings implements UseCase<List<DateSetting>, NoParams> {
  final DateSettingsRepository repository;
  GetDateSettings(this.repository);
  @override
  Future<Either<Failure, List<DateSetting>>> call(NoParams params) async {
    return await repository.getDateSettings();
  }
}
