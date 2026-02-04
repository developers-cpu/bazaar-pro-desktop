import '../../models/profit_and_loss_report_model.dart';
import '../../../../../core/errors/exceptions.dart';

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

    final List<ProfitAndLossReportModel> mockData = [
      const ProfitAndLossReportModel(
        id: '1',
        userName: 'PATIL',
        percentage: 100.00,
        releasePL: -124191.00,
        brokerage: 0,
        m2m: -585,
        netPL: -585,
        ourBrokerage: -585,
        ourPercentage: -1837.57,
      ),
      const ProfitAndLossReportModel(
        id: '2',
        userName: 'DEMO4',
        percentage: 100.00,
        releasePL: -124191.00,
        brokerage: 0,
        m2m: 381.00,
        netPL: -585,
        ourBrokerage: -585,
        ourPercentage: -2375.06,
      ),
      const ProfitAndLossReportModel(
        id: '3',
        userName: 'PATIL',
        percentage: 100.00,
        releasePL: -124191.00,
        brokerage: 0,
        m2m: -585,
        netPL: -585,
        ourBrokerage: 6650.00,
        ourPercentage: 68.37,
      ),
      const ProfitAndLossReportModel(
        id: '4',
        userName: 'DEMO4',
        percentage: 100.00,
        releasePL: 124191.00,
        brokerage: 0,
        m2m: 21721.00,
        netPL: -585,
        ourBrokerage: 21721.00,
        ourPercentage: 12269.81,
      ),
    ];

    if (userId != null && userId.isNotEmpty) {
      return mockData
          .where((item) => item.userName.toLowerCase() == userId.toLowerCase())
          .toList();
    }

    return mockData;
  }
}
