import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_quantity_setting/user_quantity_setting.dart';
import 'package:bazarpro/features/users/domain/entities/user_quantity_setting/user_quantity_setting_metadata.dart';
import 'package:dartz/dartz.dart';
abstract class UserQuantitySettingsRepository {
  Future<Either<Failure, List<UserQuantitySetting>>> getUserQuantitySettings(
    String userId,
  );
  Future<Either<Failure, UserQuantitySettingMetadata>>
  getQuantitySettingsMetadata();
}
