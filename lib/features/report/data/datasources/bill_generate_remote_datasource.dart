import 'package:bazarpro/features/report/data/models/bill_generate_report_model.dart';
import '../../../../../core/errors/exceptions.dart';

abstract class BillGenerateRemoteDataSource {
  Future<BillGenerateReportModel> getBillGenerateReport({
    required String userId,
    required String billFormat,
    required String billType,
  });
}

class BillGenerateRemoteDataSourceImpl implements BillGenerateRemoteDataSource {
  @override
  Future<BillGenerateReportModel> getBillGenerateReport({
    required String userId,
    required String billFormat,
    required String billType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final mockResponse = {
      "headerInfo": {
        "userName": "AER01",
        "dateRange": "BILL SUMMRY 27-OCT-25 TO 01-NOV-25",
        "billNo": "AER01",
      },
      "exchangeReports": [
        {
          "exchangeName": "NSE",
          "trades": [
            {
              "exchange": "NSE",
              "script": "NIFTY25NOV25",
              "buyQty": 1000,
              "buyPrice": 1000.0,
              "sellQty": 1000,
              "brokerage": 0.0,
              "profitLoss": 0.0,
            },
            {
              "exchange": "NSE",
              "script": "NIFTY25NOV25",
              "sellQty": 1000,
              "brokerage": 0.0,
              "profitLoss": 0.0,
            },
            {
              "exchange": "NSE",
              "script": "NIFTY25NOV25",
              "buyQty": 500,
              "buyPrice": 500.0,
              "sellQty": 1250,
              "brokerage": 0.0,
              "profitLoss": 0.0,
            },
            {
              "exchange": "NSE",
              "script": "NIFTY25NOV25",
              "buyQty": 250,
              "buyPrice": 250.0,
              "sellQty": 49000,
              "sellPrice": 1000.0,
              "brokerage": 1000.0,
              "profitLoss": 51000.0,
            },
          ],
          "total": {
            "totalBuyQty": 1750,
            "totalSellQty": 1750,
            "totalBrokerage": 1000.0,
            "totalProfitLoss": 51000.0,
          },
        },
        {
          "exchangeName": "MCX",
          "trades": [
            {
              "exchange": "MCX",
              "script": "GOLD05DEC25",
              "buyQty": 500,
              "buyPrice": 56000.0,
              "sellQty": 56000,
              "brokerage": 0.0,
              "profitLoss": 0.0,
            },
            {
              "exchange": "MCX",
              "script": "GOLD05DEC25",
              "buyQty": 500,
              "buyPrice": 55500.0,
              "sellQty": 55500,
              "brokerage": 1500.0,
              "profitLoss": 1500.0,
            },
            {
              "exchange": "MCX",
              "script": "GOLD05DEC25",
              "buyQty": 200,
              "buyPrice": 5000.0,
              "sellQty": 5000,
              "brokerage": 1500.0,
              "profitLoss": 5000.0,
            },
            {
              "exchange": "MCX",
              "script": "GOLD05DEC25",
              "buyQty": 250,
              "buyPrice": 500.0,
              "sellQty": 500,
              "brokerage": 500.0,
              "profitLoss": 500.0,
            },
          ],
          "total": {
            "totalBuyQty": 950,
            "totalSellQty": 500,
            "totalBrokerage": 3500.0,
            "totalProfitLoss": 117000.0,
          },
        },
      ],
      "scriptWiseSummary": [
        {
          "exchange": "NSE",
          "script": "NIFTY25NOV25",
          "mtm": 50000.0,
          "brokerage": 1000.0,
          "netAmount": 490000.0,
        },
        {
          "exchange": "NSE",
          "script": "BANKNIFTY25NOV25",
          "mtm": -250000.0,
          "brokerage": 1500.0,
          "netAmount": -251500.0,
        },
        {
          "exchange": "MCX",
          "script": "GOLD05DEC25",
          "mtm": 100000.0,
          "brokerage": 600.0,
          "netAmount": 99400.0,
        },
        {
          "exchange": "GIFT",
          "script": "GIFT05DEC25",
          "mtm": -7500.0,
          "brokerage": 750.0,
          "netAmount": 6750.0,
        },
        {
          "exchange": "OTHER",
          "script": "DOWJONES21DEC25",
          "mtm": 100000.0,
          "brokerage": 600.0,
          "netAmount": 99400.0,
        },
      ],
      "overallTotal": {
        "totalMtm": -7500.0,
        "totalBrokerage": 750.0,
        "totalNetAmount": 6750.0,
      },
    };

    try {
      return BillGenerateReportModel.fromJson(mockResponse);
    } catch (e) {
      throw ServerException('Data parsing error: $e');
    }
  }
}
