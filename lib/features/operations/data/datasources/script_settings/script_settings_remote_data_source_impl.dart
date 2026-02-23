import '../../models/script_settings/script_setting_model.dart';
import 'script_settings_remote_data_source.dart';

class ScriptSettingsRemoteDataSourceImpl
    implements ScriptSettingsRemoteDataSource {
  final List<ScriptSettingModel> _mockData = [
    const ScriptSettingModel(
      id: '1',
      symbol: 'ABB25DECFUT',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isBanned: true,
      cutDate: '06/05/25',
    ),
    const ScriptSettingModel(
      id: '2',
      symbol: 'ABCAPITAL25DECFUT',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isBanned: false,
      cutDate: '06/05/25',
    ),
    const ScriptSettingModel(
      id: '3',
      symbol: 'ADANIENSOL25DECFUT',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isBanned: false,
      cutDate: '06/05/25',
    ),
    const ScriptSettingModel(
      id: '4',
      symbol: '360ONE25DECFUT',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isBanned: true,
      cutDate: '06/05/25',
    ),
    const ScriptSettingModel(
      id: '5',
      symbol: 'BAJAJ-AUTO25DECFUT',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isBanned: true,
      cutDate: '06/05/25',
    ),
    const ScriptSettingModel(
      id: '6',
      symbol: 'AXISBANK25DECFUT',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isBanned: true,
      cutDate: '06/05/25',
    ),
    const ScriptSettingModel(
      id: '7',
      symbol: 'ADANIENT25DECFUT',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isBanned: true,
      cutDate: '06/05/25',
    ),
    const ScriptSettingModel(
      id: '8',
      symbol: 'ADANIGREEN25DECFUT',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isBanned: true,
      cutDate: '06/05/25',
    ),
    const ScriptSettingModel(
      id: '9',
      symbol: 'AUROPHARMA25DECFUT',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      isBanned: true,
      cutDate: '06/05/25',
    ),
  ];

  @override
  Future<List<ScriptSettingModel>> getScriptSettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockData;
  }

  @override
  Future<void> updateScriptSettings(List<ScriptSettingModel> settings) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return;
  }
}
