import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/script_settings/script_setting.dart';
import '../../repositories/script_settings/script_settings_repository.dart';

class GetScriptSettings implements UseCase<List<ScriptSetting>, NoParams> {
  final ScriptSettingsRepository repository;
  GetScriptSettings(this.repository);
  @override
  Future<Either<Failure, List<ScriptSetting>>> call(NoParams params) async {
    return await repository.getScriptSettings();
  }
}