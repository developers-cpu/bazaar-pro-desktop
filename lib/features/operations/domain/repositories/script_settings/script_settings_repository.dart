import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/script_settings/script_setting.dart';
abstract class ScriptSettingsRepository {
  Future<Either<Failure, List<ScriptSetting>>> getScriptSettings();
  Future<Either<Failure, void>> updateScriptSettings(
    List<ScriptSetting> settings,
  );
}
