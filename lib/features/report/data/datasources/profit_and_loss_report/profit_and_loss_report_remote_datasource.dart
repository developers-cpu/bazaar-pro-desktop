import '../../models/profit_and_loss_report_model.dart';

abstract class ProfitAndLossReportRemoteDataSource {
  Future<List<ProfitAndLossReportModel>> getProfitAndLossReport({
    String? userId,
  });
}

class ProfitAndLossReportRemoteDataSourceImpl
    implements ProfitAndLossReportRemoteDataSource {
  @override
  Future<List<ProfitAndLossReportModel>> getProfitAndLossReport({
    String? userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<ProfitAndLossReportModel> mockData =
        _generateDummyProfitAndLossReports();

    if (userId != null && userId.isNotEmpty) {
      return mockData
          .where(
            (item) =>
                item.userName.toLowerCase().contains(userId.toLowerCase()),
          )
          .toList();
    }
    return mockData;
  }

  List<ProfitAndLossReportModel> _generateDummyProfitAndLossReports() {
    final List<String> userNames = [
      'PATIL',
      'DEMO4',
      'ADMIN',
      'MASTER',
      'USER123',
      'TEST_OWNER',
    ];
    final List<ProfitAndLossReportModel> list = [];

    for (int i = 1; i <= 35; i++) {
      final double relPL = (i % 3 == 0) ? -(i * 5000.0) : (i * 3500.0);
      final double m2m = (i % 2 == 0) ? (i * 1200.0) : -(i * 800.0);
      final double brk = i * 50.0;
      final double netPL = relPL + m2m - brk;

      list.add(
        ProfitAndLossReportModel(
          id: i.toString(),
          userName: userNames[i % userNames.length],
          percentage: 100.00,
          releasePL: relPL,
          brokerage: brk,
          m2m: m2m,
          netPL: netPL,
          ourBrokerage: brk * 0.8,
          ourPercentage: netPL * 0.9,
        ),
      );
    }
    return list;
  }
}
