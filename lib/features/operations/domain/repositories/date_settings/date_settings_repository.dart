import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/date_settings/date_setting.dart';
abstract class DateSettingsRepository {
  Future<Either<Failure, List<DateSetting>>> getDateSettings();
  Future<Either<Failure, bool>> updateDateSettings({
    required List<String> ids,
    DateSetting? details,
  });
}
