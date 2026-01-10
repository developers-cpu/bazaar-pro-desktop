import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_datasource.dart';

/// Dashboard Repository Implementation
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSource _dataSource;

  DashboardRepositoryImpl({required DashboardDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<TradeReportData>> getTradeReports({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
  }) async {
    return await _dataSource.getTradeReports(
      clientId: clientId,
      showPeriod: showPeriod,
      exchanges: exchanges,
    );
  }

  @override
  Future<List<SymbolReportData>> getSymbolReports({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
    int topCount = 10,
  }) async {
    return await _dataSource.getSymbolReports(
      clientId: clientId,
      showPeriod: showPeriod,
      exchanges: exchanges,
      topCount: topCount,
    );
  }

  @override
  Future<DashboardSummary> getDashboardSummary() async {
    return await _dataSource.getDashboardSummary();
  }

  @override
  Future<DashboardData> getDashboardData({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
    int topCount = 10,
  }) async {
    final results = await Future.wait([
      getTradeReports(
        clientId: clientId,
        showPeriod: showPeriod,
        exchanges: exchanges,
      ),
      getSymbolReports(
        clientId: clientId,
        showPeriod: showPeriod,
        exchanges: exchanges,
        topCount: topCount,
      ),
      getDashboardSummary(),
    ]);

    return DashboardData(
      tradeReports: results[0] as List<TradeReportData>,
      symbolReports: results[1] as List<SymbolReportData>,
      summary: results[2] as DashboardSummary,
    );
  }
}