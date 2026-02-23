import '../../models/script_settings/script_setting_model.dart';
abstract class ScriptSettingsRemoteDataSource {
  Future<List<ScriptSettingModel>> getScriptSettings();
  Future<void> updateScriptSettings(List<ScriptSettingModel> settings);
}
