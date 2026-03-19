import 'date_settings_remote_data_source.dart';
import '../../models/date_settings/date_setting_model.dart';

class DateSettingsRemoteDataSourceImpl implements DateSettingsRemoteDataSource {
  final List<DateSettingModel> _mockDateSettings = _generateMockData();
  static List<DateSettingModel> _generateMockData() {
    final exchanges = [
      'NSE',
      'MCX',
      'CE/PE',
      'GIFT',
      'OTHERS',
      'COMEX',
      'CRYPTO',
      'FOREX',
      'USSTOCK',
    ];
    final symbols = {
      'NSE': [
        '360NE',
        'AARTIND',
        'ABB',
        'ABBOTINDIA',
        'ABCAPITAL',
        'ACC',
        'AMBER',
        'ALKEM',
        'AMBUJACEM',
        'ANGELONE',
      ],
      'MCX': [
        '360NE',
        'AARTIND',
        'ABB',
        'ABBOTINDIA',
        'ABCAPITAL',
        'ACC',
        'AMBER',
        'ALKEM',
        'AMBUJACEM',
        'ANGELONE',
      ],
      'CE/PE': ['360NE', 'AARTIND', 'ABB', 'ABBOTINDIA', 'ABCAPITAL'],
      'GIFT': ['360NE', 'AARTIND', 'ABB', 'ABBOTINDIA', 'ABCAPITAL'],
      'OTHERS': ['360NE', 'AARTIND', 'ABB'],
      'COMEX': ['GOLD', 'SILVER', 'COPPER'],
      'CRYPTO': ['BTC', 'ETH', 'DOGE'],
      'FOREX': ['USDINR', 'EURINR', 'GBPINR'],
      'USSTOCK': ['AAPL', 'TSLA', 'MSFT'],
    };
    final List<DateSettingModel> result = [];
    int idCounter = 1;
    for (final exchange in exchanges) {
      final exchangeSymbols = symbols[exchange] ?? [];
      for (final symbol in exchangeSymbols) {
        result.add(
          DateSettingModel(
            id: '${idCounter++}',
            exchange: exchange,
            symbol: symbol,
            expiryDate: '26/12/25',
            launchDate: '26/12/25',
            closeDate: '26/12/25',
            cutDate: '26/12/25',
            updatedOn: '26/12/25 | 12:00:30 AM',
            updatedBy: 'Super Admin',
          ),
        );
      }
    }
    return result;
  }

  @override
  Future<List<DateSettingModel>> getDateSettings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDateSettings;
  }

  @override
  Future<bool> updateDateSettings({
    required List<String> ids,
    DateSettingModel? details,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}