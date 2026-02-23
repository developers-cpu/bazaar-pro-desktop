import '../../models/exchange_settings/exchange_setting_model.dart';
abstract class ExchangeSettingsRemoteDataSource {
  Future<List<ExchangeSettingModel>> getExchangeSettings();
  Future<bool> updateExchangeSettings({required List<String> ids});
  Future<List<DefaultSymbolModel>> getDefaultSymbols({
    required String exchange,
  });
}
