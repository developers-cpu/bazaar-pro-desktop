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
      "profitList": [
        {
          "userId": "1",
          "username": "Raj",
          "userType": "M-01",
          "pnl": 10000.0,
          "brokerage": 15000.0,
          "percentageWise": 15000.0,
          "total": 25000.0,
        },
        {
          "userId": "2",
          "username": "Kush",
          "userType": "C",
          "pnl": 12000.0,
          "brokerage": 8000.0,
          "percentageWise": 8000.0,
          "total": 20000.0,
        },
        {
          "userId": "3",
          "username": "My brokerage",
          "userType": "",
          "pnl": 5000.0,
          "brokerage": 2000.0,
          "percentageWise": 2000.0,
          "total": 7000.0,
        },
      ],
      "lossList": [
        {
          "userId": "1",
          "username": "Raj",
          "userType": "M-01",
          "pnl": 10000.0,
          "brokerage": 15000.0,
          "percentageWise": 15000.0,
          "total": -25000.0,
        },
        {
          "userId": "2",
          "username": "Kush",
          "userType": "C",
          "pnl": 12000.0,
          "brokerage": 8000.0,
          "percentageWise": 8000.0,
          "total": -20000.0,
        },
        {
          "userId": "3",
          "username": "My brokerage",
          "userType": "",
          "pnl": 5000.0,
          "brokerage": 2000.0,
          "percentageWise": 2000.0,
          "total": -7000.0,
        },
      ],
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