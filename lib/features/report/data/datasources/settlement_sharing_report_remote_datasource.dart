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
          "total": 74963.0,
        },
        {
          "userId": "2",
          "username": "Kush",
          "userType": "C",
          "pnl": 10000.0,
          "percentWise": 15000.0,
          "total": 74963.0,
        },
        {
          "userId": "3",
          "username": "My brokerage",
          "userType": "",
          "pnl": 1500.0,
          "percentWise": 5000.0,
          "total": 121.0,
        },
      ],
      "lossList": [
        {
          "userId": "1",
          "username": "Raj",
          "userType": "M-01",
          "pnl": 10000.0,
          "percentWise": 15000.0,
          "total": -74963.0,
        },
        {
          "userId": "2",
          "username": "Kush",
          "userType": "C",
          "pnl": 10000.0,
          "percentWise": 15000.0,
          "total": -74963.0,
        },
        {
          "userId": "3",
          "username": "My brokerage",
          "userType": "",
          "pnl": 1500.0,
          "percentWise": 5000.0,
          "total": -74963.0,
        },
      ],
      "profitTotal": {
        "totalPnl": 7520500.0,
        "totalPercentWise": 24100.0,
        "totalAmount": 7508400.0,
      },
      "lossTotal": {
        "totalPnl": 7520500.0,
        "totalPercentWise": 24100.0,
        "totalAmount": -74963.0,
      },
    };
    try {
      return SettlementSharingReportModel.fromJson(mockResponse);
    } catch (e) {
      throw ServerException('Data parsing error: $e');
    }
  }
}
