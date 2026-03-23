import 'package:bazarpro/features/view/data/models/trade_margin/trade_margin_model.dart';

abstract class TradeMarginRemoteDataSource {
  Future<List<TradeMarginModel>> getTradeMargins({
    String? exchange,
    String? search,
  });
}

class TradeMarginRemoteDataSourceImpl implements TradeMarginRemoteDataSource {
  @override
  Future<List<TradeMarginModel>> getTradeMargins({
    String? exchange,
    String? search,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<TradeMarginModel> mockData = [
      TradeMarginModel(
        exchange: 'MCX',
        symbol: '360NE',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 500,
        cfMarginPct: 500,
        intMarginAmt: -0,
        cfMarginAmt: -0,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'AARTIND',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 2500,
        cfMarginPct: 2500,
        intMarginAmt: 2500,
        cfMarginAmt: 2500,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'ABB',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 0,
        cfMarginPct: 0,
        intMarginAmt: 2500,
        cfMarginAmt: 2500,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'ABBOTINDIA',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 0,
        cfMarginPct: 0,
        intMarginAmt: 2500,
        cfMarginAmt: 2500,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'ABCAPITAL',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 2500,
        cfMarginPct: 2500,
        intMarginAmt: 2500,
        cfMarginAmt: 2500,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'ACC',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 2500,
        cfMarginPct: 2500,
        intMarginAmt: 0,
        cfMarginAmt: 0,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'AMBER',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 2500,
        cfMarginPct: 2500,
        intMarginAmt: 2500,
        cfMarginAmt: 2500,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'ALKEM',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 2500,
        cfMarginPct: 2500,
        intMarginAmt: 2500,
        cfMarginAmt: 2500,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'AMBUJACEM',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 2500,
        cfMarginPct: 2500,
        intMarginAmt: 2500,
        cfMarginAmt: 2500,
      ),
      TradeMarginModel(
        exchange: 'NSE',
        symbol: 'NIFTY',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 2500,
        cfMarginPct: 2500,
        intMarginAmt: 0,
        cfMarginAmt: 0,
      ),
      TradeMarginModel(
        exchange: 'NSE',
        symbol: 'BANKNIFTY',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 15000,
        cfMarginPct: 15000,
        intMarginAmt: 15000,
        cfMarginAmt: 15000,
      ),
      TradeMarginModel(
        exchange: 'NSE',
        symbol: 'RELIANCE',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 5000,
        cfMarginPct: 5000,
        intMarginAmt: 5000,
        cfMarginAmt: 5000,
      ),
      TradeMarginModel(
        exchange: 'NSE',
        symbol: 'TCS',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 3000,
        cfMarginPct: 3000,
        intMarginAmt: 3000,
        cfMarginAmt: 3000,
      ),
      TradeMarginModel(
        exchange: 'CE/PE',
        symbol: 'NIFTY25N0425550CE',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 95,
        cfMarginPct: 95,
        intMarginAmt: 95,
        cfMarginAmt: 95,
      ),
      TradeMarginModel(
        exchange: 'CE/PE',
        symbol: 'NIFTY25N0425600CE',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        intMarginPct: 178,
        cfMarginPct: 178,
        intMarginAmt: 178,
        cfMarginAmt: 178,
      ),
    ];
    var filteredList = mockData;
    if (exchange != null && exchange != 'All') {
      filteredList = filteredList
          .where((item) => item.exchange == exchange)
          .toList();
    }
    if (search != null && search.isNotEmpty) {
      filteredList = filteredList
          .where(
            (item) => item.symbol.toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
    }
    return filteredList;
  }
}
