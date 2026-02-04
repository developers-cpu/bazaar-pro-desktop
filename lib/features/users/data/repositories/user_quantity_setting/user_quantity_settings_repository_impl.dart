import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user_quantity_setting/user_quantity_setting.dart';
import '../../../domain/entities/user_quantity_setting/user_quantity_setting_metadata.dart';
import '../../../domain/repositories/user_quantity_setting/user_quantity_settings_repository.dart';
import '../../datasources/user_quantity_setting/user_quantity_settings_datasource.dart';
class UserQuantitySettingsRepositoryImpl
    implements UserQuantitySettingsRepository {
  final UserQuantitySettingsDataSource dataSource;
  UserQuantitySettingsRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<UserQuantitySetting>>> getUserQuantitySettings(
    String userId,
  ) async {
    try {
      final models = await dataSource.getUserQuantitySettings(userId);
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, UserQuantitySettingMetadata>>
  getQuantitySettingsMetadata() async {
    try {
      final model = await dataSource.getQuantitySettingsMetadata();
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
