import '../models/settlement_sharing_report_model.dart';
import '../../../../../core/errors/exceptions.dart';

abstract class SettlementSharingReportRemoteDataSource {
  Future<SettlementSharingReportModel> getSettlementSharingReport({
    required String dateRange,
    String? userId,
  });
}

class SettlementSharingReportRemoteDataSourceImpl
    implements SettlementSharingReportRemoteDataSource {
  @override
  Future<SettlementSharingReportModel> getSettlementSharingReport({
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
          "percentWise": 15000.0,
          "total": 25000.0,
        },
        {
          "userId": "2",
          "username": "Kush",
          "userType": "C",
          "pnl": 12000.0,
          "percentWise": 8000.0,
          "total": 20000.0,
        },
        {
          "userId": "3",
          "username": "My brokerage",
          "userType": "",
          "pnl": 5000.0,
          "percentWise": 2000.0,
          "total": 7000.0,
        },
      ],
      "lossList": [
        {
          "userId": "1",
          "username": "Raj",
          "userType": "M-01",
          "pnl": 10000.0,
          "percentWise": 15000.0,
          "total": -25000.0,
        },
        {
          "userId": "2",
          "username": "Kush",
          "userType": "C",
          "pnl": 12000.0,
          "percentWise": 8000.0,
          "total": -20000.0,
        },
        {
          "userId": "3",
          "username": "My brokerage",
          "userType": "",
          "pnl": 5000.0,
          "percentWise": 2000.0,
          "total": -7000.0,
        },
      ],
      "profitTotal": {
        "totalPnl": 27000.0,
        "totalPercentWise": 25000.0,
        "totalAmount": 52000.0,
      },
      "lossTotal": {
        "totalPnl": 27000.0,
        "totalPercentWise": 25000.0,
        "totalAmount": -52000.0,
      },
    };
    try {
      return SettlementSharingReportModel.fromJson(mockResponse);
    } catch (e) {
      throw ServerException('Data parsing error: $e');
    }
  }
}