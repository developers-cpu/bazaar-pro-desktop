import '../../models/trade_settings/trade_setting_model.dart';
abstract class TradeSettingsRemoteDataSource {
  Future<List<TradeSettingModel>> getTradeSettings();
  Future<bool> updateTradeSettings({
    required List<String> ids,
    TradeSettingModel? details,
  });
}
