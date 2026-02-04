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
    final List<SymbolWisePositionReportModel> mockData = [
      const SymbolWisePositionReportModel(
        id: '1',
        exchange: 'NSE',
        symbol: 'CRUDEOIL 18SEP2024',
        netQty: 100,
        netMs: 1000,
        carryFwdQty: 0,
        carryFwdMs: 0,
        openQty: 50,
        openMs: 500,
        totalQty: 150,
        totalMs: 1500,
        buyQty: 200,
        buyMs: 2000,
        sellQty: 100,
        sellMs: 1000,
        netAvgPrice: 6500,
        cmp: 6550,
        m2m: 5000,
        releasePL: 2000,
        netPL: 7000,
        brokerage: 100,
        netPLWithBrokerage: 6900,
      ),
      const SymbolWisePositionReportModel(
        id: '2',
        exchange: 'MCX',
        symbol: 'GOLD 05OCT2024',
        netQty: -10,
        netMs: -100,
        carryFwdQty: 0,
        carryFwdMs: 0,
        openQty: -5,
        openMs: -50,
        totalQty: -15,
        totalMs: -150,
        buyQty: 10,
        buyMs: 100,
        sellQty: 20,
        sellMs: 200,
        netAvgPrice: 58000,
        cmp: 57800,
        m2m: 2000,
        releasePL: 1000,
        netPL: 3000,
        brokerage: 200,
        netPLWithBrokerage: 2800,
      ),
    ];
    if (exchange != null && exchange != 'All') {
      return mockData.where((e) => e.exchange == exchange).toList();
    }
    return mockData;
  }
}
