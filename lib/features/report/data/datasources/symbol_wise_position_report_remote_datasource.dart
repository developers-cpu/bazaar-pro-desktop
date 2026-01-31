import '../models/symbol_wise_position_report_model.dart';

abstract class SymbolWisePositionReportRemoteDataSource {
  Future<List<SymbolWisePositionReportModel>> getSymbolWisePositionReport({
    String? exchange,
    String? symbol,
  });
}

class SymbolWisePositionReportRemoteDataSourceImpl
    implements SymbolWisePositionReportRemoteDataSource {
  @override
  Future<List<SymbolWisePositionReportModel>> getSymbolWisePositionReport({
    String? exchange,
    String? symbol,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<SymbolWisePositionReportModel> mockData = [
      const SymbolWisePositionReportModel(
        id: '1',
        exchange: 'NSE',
        symbol: 'NIFTY30DEC',
        netQty: -10.00,
        netQtyPercent: 10.00,
        avgPrice: 26387.40,
        brokerage: 0.00,
        wbaPrice: 26387.40,
        cmp: 26076.00,
        pl: 3082.00,
        plPercent: -3080.00,
        brokeragePercent: 0.00,
      ),
      const SymbolWisePositionReportModel(
        id: '2',
        exchange: 'NSE',
        symbol: 'BANKNIFTY30DEC',
        netQty: -35.00,
        netQtyPercent: 35.00,
        avgPrice: 60225.00,
        brokerage: 105.39,
        wbaPrice: 60221.99,
        cmp: 59371.20,
        pl: 29834.00,
        plPercent: -29785.00,
        brokeragePercent: 105.39,
      ),
      const SymbolWisePositionReportModel(
        id: '3',
        exchange: 'NSE',
        symbol: 'JSWSTEEL30DEC',
        netQty: -500.00,
        netQtyPercent: 0.00,
        avgPrice: 1157.10,
        brokerage: 842.88,
        wbaPrice: 1155.41,
        cmp: 1158.20,
        pl: -900.00,
        plPercent: 0.00,
        brokeragePercent: 44.36,
      ),
      const SymbolWisePositionReportModel(
        id: '4',
        exchange: 'MCX',
        symbol: 'GOLDPETAL',
        netQty: 10.00,
        netQtyPercent: 5.00,
        avgPrice: 59000.00,
        brokerage: 50.00,
        wbaPrice: 59050.00,
        cmp: 59200.00,
        pl: 2000.00,
        plPercent: 15.00,
        brokeragePercent: 10.00,
      ),
    ];

    return mockData.where((item) {
      if (exchange != null &&
          exchange.isNotEmpty &&
          item.exchange.toLowerCase() != exchange.toLowerCase()) {
        return false;
      }
      if (symbol != null && symbol.isNotEmpty) {
        return item.symbol.toLowerCase() == symbol.toLowerCase();
      }
      return true;
    }).toList();
  }
}
