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
        marginPercentage: 10000,
        marginAmount: 10000,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'AARTIND',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        marginPercentage: 1500,
        marginAmount: 1500,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'ABB',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        marginPercentage: 0,
        marginAmount: 0,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'ABBOTINDIA',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        marginPercentage: 0,
        marginAmount: 0,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'ABCAPITAL',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        marginPercentage: 1000,
        marginAmount: 1000,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'ACC',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        marginPercentage: 2000,
        marginAmount: 2000,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'AMBER',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        marginPercentage: 1000,
        marginAmount: 1000,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'ALKEM',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        marginPercentage: 2000,
        marginAmount: 2000,
      ),
      TradeMarginModel(
        exchange: 'MCX',
        symbol: 'AMBUJACEM',
        expiryDate: DateTime(2025, 12, 26, 0, 0, 0),
        marginPercentage: 1000,
        marginAmount: 1000,
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
