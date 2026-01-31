import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/users/domain/entities/user_quantity_setting/user_quantity_setting_metadata.dart';
import 'package:bazarpro/features/users/domain/repositories/user_quantity_setting/user_quantity_settings_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserQuantitySettingsMetadata
    implements UseCase<UserQuantitySettingMetadata, NoParams> {
  final UserQuantitySettingsRepository repository;

  GetUserQuantitySettingsMetadata(this.repository);

  @override
  Future<Either<Failure, UserQuantitySettingMetadata>> call(NoParams params) {
    return repository.getQuantitySettingsMetadata();
  }
}
