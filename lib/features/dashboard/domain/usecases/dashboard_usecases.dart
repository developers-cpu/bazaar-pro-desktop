import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;
  GetDashboardDataUseCase({required this.repository});
  Future<DashboardData> call({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
    int topCount = 10,
  }) async {
    return await repository.getDashboardData(
      clientId: clientId,
      showPeriod: showPeriod,
      exchanges: exchanges,
      topCount: topCount,
    );
  }
}

class GetTradeReportsUseCase {
  final DashboardRepository repository;
  GetTradeReportsUseCase({required this.repository});
  Future<List<TradeReportData>> call({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
  }) async {
    return await repository.getTradeReports(
      clientId: clientId,
      showPeriod: showPeriod,
      exchanges: exchanges,
    );
  }
}

class GetSymbolReportsUseCase {
  final DashboardRepository repository;
  GetSymbolReportsUseCase({required this.repository});
  Future<List<SymbolReportData>> call({
    String? clientId,
    String? showPeriod,
    List<String>? exchanges,
    int topCount = 10,
  }) async {
    return await repository.getSymbolReports(
      clientId: clientId,
      showPeriod: showPeriod,
      exchanges: exchanges,
      topCount: topCount,
    );
  }
}

class GetDashboardSummaryUseCase {
  final DashboardRepository repository;
  GetDashboardSummaryUseCase({required this.repository});
  Future<DashboardSummary> call() async {
    return await repository.getDashboardSummary();
  }
}
