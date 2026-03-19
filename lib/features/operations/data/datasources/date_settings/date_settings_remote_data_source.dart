import '../../models/date_settings/date_setting_model.dart';

abstract class DateSettingsRemoteDataSource {
  Future<List<DateSettingModel>> getDateSettings();
  Future<bool> updateDateSettings({
    required List<String> ids,
    DateSettingModel? details,
  });
}