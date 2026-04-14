import '../../models/exchange_settings/exchange_setting_model.dart';
import '../../models/exchange_settings/exchange_market_timing_model.dart';
import '../../models/exchange_settings/exchange_holiday_model.dart';
import '../../models/exchange_settings/exchange_timing_model.dart';

abstract class ExchangeSettingsRemoteDataSource {
  Future<List<ExchangeSettingModel>> getExchangeSettings();
  Future<bool> updateExchangeSettings({required List<String> ids});
  Future<List<DefaultSymbolModel>> getDefaultSymbols({
    required String exchange,
  });
  Future<List<ExchangeMarketTimingModel>> getMarketTimings();
  Future<bool> updateMarketTimingsFromExcel({required List<int> bytes});
  Future<bool> updateMarketTimingStatus({
    required String id,
    required bool isOn,
  });
  Future<List<ExchangeHolidayModel>> getExchangeHolidays({
    required String exchange,
  });
  Future<bool> updateExchangeHoliday(ExchangeHolidayModel holiday);
  Future<bool> deleteExchangeHoliday(String id);
  Future<List<ExchangeTimingModel>> getExchangeTimings({
    required String exchange,
  });
  Future<bool> updateExchangeTiming(ExchangeTimingModel timing);
  Future<bool> deleteExchangeTiming(String id);
}
