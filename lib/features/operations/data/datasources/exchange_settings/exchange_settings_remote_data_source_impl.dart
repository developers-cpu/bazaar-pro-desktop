import 'exchange_settings_remote_data_source.dart';
import '../../models/exchange_settings/exchange_setting_model.dart';
import '../../models/exchange_settings/exchange_market_timing_model.dart';
import '../../models/exchange_settings/exchange_holiday_model.dart';
import '../../models/exchange_settings/exchange_timing_model.dart';

class ExchangeSettingsRemoteDataSourceImpl
    implements ExchangeSettingsRemoteDataSource {
  final List<ExchangeSettingModel> _mockExchangeSettings = [
    ExchangeSettingModel(
      id: '1',
      exchange: 'MCX',
      betweenHighLowLimitPlace: true,
      autoTickSize: true,
      tickSize: '0.05',
      orderType: ['Market', 'SL', 'Limit'],
      oddLot: false,
      marketPriceType: 'Full',
      sequence: '01',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
    ),
    ExchangeSettingModel(
      id: '2',
      exchange: 'NSE',
      betweenHighLowLimitPlace: false,
      autoTickSize: false,
      tickSize: '10',
      orderType: ['SL', 'Limit'],
      oddLot: true,
      marketPriceType: 'Close',
      sequence: '02',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
    ),
    ExchangeSettingModel(
      id: '3',
      exchange: 'CE/PE',
      betweenHighLowLimitPlace: true,
      autoTickSize: true,
      tickSize: '0.05',
      orderType: ['Limit'],
      oddLot: false,
      marketPriceType: 'Block',
      sequence: '03',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
    ),
    ExchangeSettingModel(
      id: '4',
      exchange: 'GIFT',
      betweenHighLowLimitPlace: false,
      autoTickSize: false,
      tickSize: '10',
      orderType: ['Market'],
      oddLot: true,
      marketPriceType: 'Full',
      sequence: '04',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
    ),
    ExchangeSettingModel(
      id: '5',
      exchange: 'OTHERS',
      betweenHighLowLimitPlace: true,
      autoTickSize: true,
      tickSize: '0.05',
      orderType: ['Market', 'SL'],
      oddLot: false,
      marketPriceType: 'Close',
      sequence: '05',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
    ),
    ExchangeSettingModel(
      id: '6',
      exchange: 'CRYPTO',
      betweenHighLowLimitPlace: false,
      autoTickSize: false,
      tickSize: '10',
      orderType: ['Market', 'SL'],
      oddLot: false,
      marketPriceType: 'Block',
      sequence: '06',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
    ),
    ExchangeSettingModel(
      id: '7',
      exchange: 'COMEX',
      betweenHighLowLimitPlace: true,
      autoTickSize: false,
      tickSize: '0.05',
      orderType: ['Market', 'Limit'],
      oddLot: false,
      marketPriceType: 'Full',
      sequence: '07',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
    ),
    ExchangeSettingModel(
      id: '8',
      exchange: 'FOREX',
      betweenHighLowLimitPlace: true,
      autoTickSize: false,
      tickSize: '10',
      orderType: ['Market', 'SL', 'Limit'],
      oddLot: false,
      marketPriceType: 'Full',
      sequence: '08',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
    ),
    ExchangeSettingModel(
      id: '9',
      exchange: 'USSTOCK',
      betweenHighLowLimitPlace: false,
      autoTickSize: true,
      tickSize: '0.05',
      orderType: ['Market', 'SL', 'Limit'],
      oddLot: false,
      marketPriceType: 'Close',
      sequence: '09',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
    ),
  ];
  final Map<String, List<DefaultSymbolModel>> _mockDefaultSymbols = {
    'MCX': [
      DefaultSymbolModel(
        id: 'd1',
        symbol: 'ABB25DECFUT',
        exchange: 'MCX',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: true,
      ),
      DefaultSymbolModel(
        id: 'd2',
        symbol: 'ABCAPITAL25DECFUT',
        exchange: 'MCX',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: true,
      ),
      DefaultSymbolModel(
        id: 'd3',
        symbol: 'ADANIENSO25DECFUT',
        exchange: 'MCX',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: true,
      ),
      DefaultSymbolModel(
        id: 'd4',
        symbol: '360ONE25DECFUT',
        exchange: 'MCX',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: true,
      ),
      DefaultSymbolModel(
        id: 'd5',
        symbol: 'BAJAJ-AUTO25DECFUT',
        exchange: 'MCX',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: true,
      ),
      DefaultSymbolModel(
        id: 'd6',
        symbol: 'AXISBANK25DECFUT',
        exchange: 'MCX',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: false,
      ),
      DefaultSymbolModel(
        id: 'd7',
        symbol: 'ADANIENT25DECFUT',
        exchange: 'MCX',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: false,
      ),
      DefaultSymbolModel(
        id: 'd8',
        symbol: 'ADANIGREEN25DECFUT',
        exchange: 'MCX',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: true,
      ),
      DefaultSymbolModel(
        id: 'd9',
        symbol: 'AUROPHARMA25DECFUT',
        exchange: 'MCX',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: true,
      ),
    ],
    'NSE': [
      DefaultSymbolModel(
        id: 'd10',
        symbol: 'NIFTY25DECFUT',
        exchange: 'NSE',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: true,
      ),
      DefaultSymbolModel(
        id: 'd11',
        symbol: 'BANKNIFTY25DECFUT',
        exchange: 'NSE',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: true,
      ),
      DefaultSymbolModel(
        id: 'd12',
        symbol: 'RELIANCE25DECFUT',
        exchange: 'NSE',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: false,
      ),
    ],
    'CE/PE': [
      DefaultSymbolModel(
        id: 'd13',
        symbol: 'NIFTY25DEC18000CE',
        exchange: 'CE/PE',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: true,
      ),
      DefaultSymbolModel(
        id: 'd14',
        symbol: 'NIFTY25DEC17500PE',
        exchange: 'CE/PE',
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
        showInWatchlist: false,
      ),
    ],
  };

  final List<ExchangeMarketTimingModel> _mockMarketTimings = [
    const ExchangeMarketTimingModel(
      id: 'm1',
      exchange: 'MCX',
      date: '13-04-2026',
      isOn: true,
      timing: '09:00 AM - 11:30 PM',
    ),
    const ExchangeMarketTimingModel(
      id: 'm2',
      exchange: 'NSE',
      date: '13-04-2026',
      isOn: true,
      timing: '09:15 AM - 03:30 PM',
    ),
    const ExchangeMarketTimingModel(
      id: 'm3',
      exchange: 'CE/PE',
      date: '13-04-2026',
      isOn: true,
      timing: '09:15 AM - 03:30 PM',
    ),
    const ExchangeMarketTimingModel(
      id: 'm4',
      exchange: 'GIFT',
      date: '13-04-2026',
      isOn: true,
      timing: '09:00 AM - 11:55 PM',
    ),
  ];

  @override
  Future<List<ExchangeSettingModel>> getExchangeSettings() async =>
      _mockExchangeSettings;
  @override
  Future<bool> updateExchangeSettings({required List<String> ids}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<List<DefaultSymbolModel>> getDefaultSymbols({
    required String exchange,
  }) async {
    return _mockDefaultSymbols[exchange] ?? [];
  }

  @override
  Future<List<ExchangeMarketTimingModel>> getMarketTimings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockMarketTimings;
  }

  @override
  Future<bool> updateMarketTimingsFromExcel({required List<int> bytes}) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<bool> updateMarketTimingStatus({
    required String id,
    required bool isOn,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  final List<ExchangeHolidayModel> _mockHolidays = [
    const ExchangeHolidayModel(
      id: 'h1',
      date: '03/31/2026',
      remark: 'Shri Mahavir Jayanti',
      exchange: 'NSE',
    ),
    const ExchangeHolidayModel(
      id: 'h2',
      date: '03/26/2026',
      remark: 'Shri Ram Navami',
      exchange: 'NSE',
    ),
    const ExchangeHolidayModel(
      id: 'h3',
      date: '03/03/2026',
      remark: 'HAPPY HOLI',
      exchange: 'NSE',
    ),
  ];

  final List<ExchangeTimingModel> _mockTimings = [
    const ExchangeTimingModel(
      id: 't1',
      days: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
      startTime: '09:16 AM',
      endTime: '03:30 PM',
      remark: 'PROFIT',
      exchange: 'NSE',
    ),
  ];

  @override
  Future<List<ExchangeHolidayModel>> getExchangeHolidays({
    required String exchange,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockHolidays.where((h) => h.exchange == exchange).toList();
  }

  @override
  Future<bool> updateExchangeHoliday(ExchangeHolidayModel holiday) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> deleteExchangeHoliday(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<List<ExchangeTimingModel>> getExchangeTimings({
    required String exchange,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockTimings.where((t) => t.exchange == exchange).toList();
  }

  @override
  Future<bool> updateExchangeTiming(ExchangeTimingModel timing) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> deleteExchangeTiming(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
