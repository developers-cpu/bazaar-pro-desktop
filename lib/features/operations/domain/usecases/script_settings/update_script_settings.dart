import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/script_settings/script_setting.dart';
import '../../repositories/script_settings/script_settings_repository.dart';

class UpdateScriptSettings implements UseCase<void, List<ScriptSetting>> {
  final ScriptSettingsRepository repository;

  UpdateScriptSettings(this.repository);

  @override
  Future<Either<Failure, void>> call(List<ScriptSetting> params) async {
    return await repository.updateScriptSettings(params);
  }
}
