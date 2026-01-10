import '../entities/dashboard_entity.dart';

/// Dashboard Repository Interface
abstract class DashboardRepository {
  /// Get trade reports data
  Future<List<TradeReportData>> getTradeReports({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
  });

  /// Get symbol wise report data
  Future<List<SymbolReportData>> getSymbolReports({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
    int topCount,
  });

  /// Get dashboard summary
  Future<DashboardSummary> getDashboardSummary();

  /// Get complete dashboard data
  Future<DashboardData> getDashboardData({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
    int topCount,
  });
}