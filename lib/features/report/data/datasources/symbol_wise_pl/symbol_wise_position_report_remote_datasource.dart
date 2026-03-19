import '../../models/symbol_wise_position_report_model.dart';

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
    final List<SymbolWisePositionReportModel> mockData = _generateDummySymbolWisePositionReports();

    if (exchange != null && exchange != 'All') {
      return mockData.where((e) => e.exchange == exchange).toList();
    }
    return mockData;
  }

  List<SymbolWisePositionReportModel> _generateDummySymbolWisePositionReports() {
    final List<String> exchanges = ['NSE', 'MCX', 'NFO', 'BTX'];
    final List<String> symbols = [
      'CRUDEOIL 18SEP2024',
      'GOLD 05OCT2024',
      'SILVER 05NOV2024',
      'COPPER 31DEC2024',
      'NIFTY 26SEP2024',
      'BANKNIFTY 26SEP2024',
      'RELIANCE 26SEP2024'
    ];

    final List<SymbolWisePositionReportModel> list = [];

    for (int i = 1; i <= 35; i++) {
      final String exch = exchanges[i % exchanges.length];
      final String sym = symbols[i % symbols.length];
      final double qty = (i % 2 == 0 ? 100.0 : -50.0) + i;
      final double avgPrice = 5000.0 + (i * 100);
      final double cmp = avgPrice + (i * 5 * (i % 3 == 0 ? -1 : 1));
      final double brk = i * 20.0;
      final double pnl = qty * (cmp - avgPrice);

      list.add(
        SymbolWisePositionReportModel(
          id: i.toString(),
          exchange: exch,
          symbol: '$sym-$i',
          netQty: qty,
          netMs: qty * 10,
          carryFwdQty: 0,
          carryFwdMs: 0,
          openQty: qty * 0.5,
          openMs: qty * 5,
          totalQty: qty * 1.5,
          totalMs: qty * 15,
          buyQty: qty > 0 ? qty : 0,
          buyMs: qty > 0 ? qty * 10 : 0,
          sellQty: qty < 0 ? qty.abs() : 0,
          sellMs: qty < 0 ? qty.abs() * 10 : 0,
          netAvgPrice: avgPrice,
          cmp: cmp,
          m2m: pnl * 0.8,
          releasePL: pnl * 0.2,
          netPL: pnl,
          brokerage: brk,
          netPLWithBrokerage: pnl - brk,
        ),
      );
    }
    return list;
  }
}