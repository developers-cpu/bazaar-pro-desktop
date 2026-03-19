import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_datasource.dart';

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
      weeklyProgress: const [
        WeeklyProgressData(label: '02 - Feb', value: 250),
        WeeklyProgressData(label: '09 - Feb', value: 380),
        WeeklyProgressData(label: '16 - Feb', value: 900),
        WeeklyProgressData(label: '23 - Feb', value: 1050),
        WeeklyProgressData(label: '02 - Mar', value: 320),
        WeeklyProgressData(label: '09 - Mar', value: 280),
        WeeklyProgressData(label: '16 - Mar', value: 410),
        WeeklyProgressData(label: '23 - Mar', value: 290),
        WeeklyProgressData(label: '30 - Mar', value: 250),
        WeeklyProgressData(label: '02 - Apr', value: 380),
        WeeklyProgressData(label: '09 - Apr', value: 900),
        WeeklyProgressData(label: '16 - Apr', value: 1050),
        WeeklyProgressData(label: '23 - Apr', value: 320),
        WeeklyProgressData(label: '02 - May', value: 280),
      ],
    );
  }
}