import '../models/settlement_report_model.dart';
import '../../../../../core/errors/exceptions.dart';

abstract class SettlementReportRemoteDataSource {
  Future<SettlementReportModel> getSettlementReport({
    required String dateRange,
    String? userId,
  });
}

class SettlementReportRemoteDataSourceImpl
    implements SettlementReportRemoteDataSource {
  @override
  Future<SettlementReportModel> getSettlementReport({
    required String dateRange,
    String? userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final mockResponse = {
      "profitList": List.generate(
        24,
        (index) => {
          "userId": "${index + 1}",
          "username": "User ${index + 1}",
          "userType": index % 3 == 0 ? "M-01" : "C",
          "pnl": 1000.0 * (index + 1),
          "brokerage": 1500.0 * (index + 1),
          "percentageWise": 1500.0 * (index + 1),
          "total": 2500.0 * (index + 1),
        },
      ),
      "lossList": List.generate(
        24,
        (index) => {
          "userId": "${index + 1}",
          "username": "User ${index + 1}",
          "userType": index % 3 == 0 ? "M-01" : "C",
          "pnl": 1000.0 * (index + 1),
          "brokerage": 1500.0 * (index + 1),
          "percentageWise": 1500.0 * (index + 1),
          "total": -2500.0 * (index + 1),
        },
      ),
      "profitTotal": {
        "totalPnl": 27000.0,
        "totalBrokerage": 25000.0,
        "totalPercentageWise": 25000.0,
        "totalAmount": 52000.0,
      },
      "lossTotal": {
        "totalPnl": 27000.0,
        "totalBrokerage": 25000.0,
        "totalPercentageWise": 25000.0,
        "totalAmount": -52000.0,
      },
    };
    try {
      return SettlementReportModel.fromJson(mockResponse);
    } catch (e) {
      throw ServerException('Data parsing error: $e');
    }
  }
}
