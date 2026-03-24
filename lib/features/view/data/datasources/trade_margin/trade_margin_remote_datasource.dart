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
    final List<TradeMarginModel> mockData = [];
    final exchangesList = ['MCX', 'NSE', 'CE/PE', 'BSE'];
    for (int i = 1; i <= 35; i++) {
      mockData.add(
        TradeMarginModel(
          exchange: exchangesList[i % 4],
          symbol: 'SYM_$i',
          expiryDate: DateTime(2025, 12, i > 28 ? 28 : i, 0, 0, 0),
          intMarginPct: (i * 100).toDouble(),
          cfMarginPct: (i * 120).toDouble(),
          intMarginAmt: (i * 1000).toDouble(),
          cfMarginAmt: (i * 1200).toDouble(),
        ),
      );
    }
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
