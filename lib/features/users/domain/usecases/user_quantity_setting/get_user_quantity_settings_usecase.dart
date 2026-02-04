import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_quantity_setting/user_quantity_setting.dart';
import 'package:bazarpro/features/users/domain/repositories/user_quantity_setting/user_quantity_settings_repository.dart';
import 'package:dartz/dartz.dart';
class GetUserQuantitySettings {
  final UserQuantitySettingsRepository repository;
  GetUserQuantitySettings(this.repository);
  Future<Either<Failure, List<UserQuantitySetting>>> call(String userId) {
    return repository.getUserQuantitySettings(userId);
  }
}
