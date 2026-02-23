import '../entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<List<TradeReportData>> getTradeReports({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
  });
  Future<List<SymbolReportData>> getSymbolReports({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
    int topCount,
  });
  Future<DashboardSummary> getDashboardSummary();
  Future<DashboardData> getDashboardData({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
    int topCount,
  });
}
