import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/script_settings/script_setting.dart';
import '../../../domain/repositories/script_settings/script_settings_repository.dart';
import '../../datasources/script_settings/script_settings_remote_data_source.dart';
import '../../models/script_settings/script_setting_model.dart';
class ScriptSettingsRepositoryImpl implements ScriptSettingsRepository {
  final ScriptSettingsRemoteDataSource remoteDataSource;
  ScriptSettingsRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<ScriptSetting>>> getScriptSettings() async {
    try {
      final settings = await remoteDataSource.getScriptSettings();
      return Right(settings);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
  @override
  Future<Either<Failure, void>> updateScriptSettings(
    List<ScriptSetting> settings,
  ) async {
    try {
      final models = settings
          .map(
            (s) => ScriptSettingModel(
              id: s.id,
              symbol: s.symbol,
              updatedOn: s.updatedOn,
              updatedBy: s.updatedBy,
              isBanned: s.isBanned,
              cutDate: s.cutDate,
            ),
          )
          .toList();
      await remoteDataSource.updateScriptSettings(models);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
