import '../models/dashboard_model.dart';

class DashboardDataSource {

  Future<List<TradeReportModel>> getTradeReports({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const TradeReportModel(
        date: '12/12/2025',
        deleted: 35,
        cancelled: 40,
        success: 67,
      ),
      const TradeReportModel(
        date: '14/12/25',
        deleted: 10,
        cancelled: 18,
        success: 88,
      ),
      const TradeReportModel(
        date: '16/12/25',
        deleted: 77,
        cancelled: 90,
        success: 28,
      ),
      const TradeReportModel(
        date: '18/12/25',
        deleted: 86,
        cancelled: 53,
        success: 15,
      ),
      const TradeReportModel(
        date: '20/12/25',
        deleted: 7,
        cancelled: 16,
        success: 100,
      ),
    ];
  }

  Future<List<SymbolReportModel>> getSymbolReports({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
    int topCount = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final allSymbols = [
      const SymbolReportModel(symbol: 'GIFTNIFTY', value: 238.68, percentage: 13.97, colorIndex: 0),
      const SymbolReportModel(symbol: 'DOWJONES', value: 141.06, percentage: 8.26, colorIndex: 1),
      const SymbolReportModel(symbol: 'NASDAQ', value: 172.12, percentage: 10.07, colorIndex: 2),
      const SymbolReportModel(symbol: 'GOLD', value: 134.84, percentage: 7.89, colorIndex: 3),
      const SymbolReportModel(symbol: 'COPPER', value: 110.35, percentage: 6.46, colorIndex: 4),
      const SymbolReportModel(symbol: 'ETHUSD', value: 164.29, percentage: 9.62, colorIndex: 5),
      const SymbolReportModel(symbol: 'BTUSD', value: 154.74, percentage: 9.06, colorIndex: 6),
      const SymbolReportModel(symbol: 'CRUDOIL', value: 145.07, percentage: 8.49, colorIndex: 7),
      const SymbolReportModel(symbol: 'NATURALGAS', value: 91.77, percentage: 5.37, colorIndex: 8),
      const SymbolReportModel(symbol: 'SILVER', value: 104.33, percentage: 6.11, colorIndex: 9),
      const SymbolReportModel(symbol: 'COPPER', value: 151.9, percentage: 8.89, colorIndex: 10),
      const SymbolReportModel(symbol: 'GOLD', value: 99.51, percentage: 5.82, colorIndex: 11),
    ];

    return allSymbols.take(topCount).toList();
  }

  Future<DashboardSummaryModel> getDashboardSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const DashboardSummaryModel(
      pnl: 1000000.00,
      bk: 1000000.00,
      other: 1000000.00,
      balance: 1000000.00,
    );
  }
}