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
    final mockResponse = {
      "headerInfo": {
        "userName": "KUB1",
        "dateRange": "GeneralSummary From 23 Feb 2026 To 01 Mar 2026",
      },
      "scriptTrades": [
        {
          "exchange": "NSE",
          "script": "ABCAPITAL26FEBFUT",
          "buyLegs": [
            {
              "date": "21-Feb 02:26:20 AM",
              "qty": 20000,
              "price": "(CF)344.10",
              "vol": 6882000.00,
            }
          ],
          "sellLegs": [
            {
              "date": "23-Feb 09:31:28 AM",
              "qty": 20000,
              "price": "349.65",
              "vol": 6993000.00,
            }
          ],
          "totalBuyQty": 20000,
          "totalBuyVol": 6882000.00,
          "totalSellQty": 20000,
          "totalSellVol": 6993000.00,
          "netDifference": 111000.00,
          "brokerage": 2097.90,
          "profitLoss": 108902.10,
        },
        {
          "exchange": "NSE",
          "script": "ADANIENSOL26FEBFUT",
          "buyLegs": [
            {
              "date": "21-Feb 02:26:20 AM",
              "qty": 9000,
              "price": "(CF)999.55",
              "vol": 8995950.00,
            }
          ],
          "sellLegs": [
            {
              "date": "23-Feb 09:31:28 AM",
              "qty": 9000,
              "price": "1001.05",
              "vol": 9009450.00,
            }
          ],
          "totalBuyQty": 9000,
          "totalBuyVol": 8995950.00,
          "totalSellQty": 9000,
          "totalSellVol": 9009450.00,
          "netDifference": 13500.00,
          "brokerage": 2702.84,
          "profitLoss": 10797.17,
        },
        {
          "exchange": "NSE",
          "script": "UNOMINDA26MARFUT",
          "buyLegs": [
            {
              "date": "26-Feb 12:07:14 PM",
              "qty": 1500,
              "price": "1240.80",
              "vol": 1861200.00,
            },
            {
              "date": "26-Feb 12:06:55 PM",
              "qty": 1500,
              "price": "1240.40",
              "vol": 1860600.00,
            },
            {
              "date": "26-Feb 12:07:04 PM",
              "qty": 1500,
              "price": "1240.80",
              "vol": 1861200.00,
            },
            {
              "date": "26-Feb 12:07:23 PM",
              "qty": 1500,
              "price": "1240.80",
              "vol": 1861200.00,
            }
          ],
          "sellLegs": [
            {
              "date": "28-Feb 10:03:30 AM",
              "qty": 6000,
              "price": "(BF)1193.00",
              "vol": 7158000.00,
            }
          ],
          "totalBuyQty": 6000,
          "totalBuyVol": 7444200.00,
          "totalSellQty": 6000,
          "totalSellVol": 7158000.00,
          "netDifference": -286200.00,
          "brokerage": 2233.26,
          "profitLoss": -288433.26,
        },
        {
          "exchange": "NSE",
          "script": "VEDL26MARFUT",
          "buyLegs": [
             {
              "date": "26-Feb 01:49:54 PM",
              "qty": 3000,
              "price": "733.85",
              "vol": 2201550.00,
            },
            {
               "date": "26-Feb 01:49:25 PM",
               "qty": 3000,
               "price": "733.85",
               "vol": 2201550.00,
            },
             {
              "date": "26-Feb 01:49:35 PM",
              "qty": 3000,
              "price": "733.90",
              "vol": 2201700.00,
             },
             {
               "date": "26-Feb 01:49:45 PM",
               "qty": 3000,
               "price": "733.80",
               "vol": 2201400.00,
             }
          ],
          "sellLegs": [
            {
              "date": "28-Feb 10:03:30 AM",
              "qty": 12000,
              "price": "(BF)720.20",
              "vol": 8642400.00,
            }
          ],
          "totalBuyQty": 12000,
          "totalBuyVol": 8806200.00,
          "totalSellQty": 12000,
          "totalSellVol": 8642400.00,
          "netDifference": -163800.00,
          "brokerage": 2641.86,
          "profitLoss": -166441.86,
        }
      ],
      "scriptWiseSummary": [
        {
          "exchange": "NSE",
          "script": "ABCAPITAL26FEBFUT",
          "total": 111000.00,
          "brokerage": 2097.90,
          "net": 108902.10,
        },
        {
          "exchange": "NSE",
          "script": "ADANIENSOL26FEBFUT",
          "total": 13500.00,
          "brokerage": 2702.84,
          "net": 10797.17,
        },
        {
          "exchange": "NSE",
          "script": "UNOMINDA26MARFUT",
          "total": -286200.00,
          "brokerage": 2233.26,
          "net": -288433.26,
        },
        {
           "exchange": "NSE",
           "script": "VEDL26MARFUT",
           "total": -163800.00,
           "brokerage": 2641.86,
           "net": -166441.86,
        }
      ],
      "summaryTotal": {
        "total": 496445.00,
        "totalBrokerage": 93600.10,
        "totalNet": 402844.90,
      },
      "carryForward": [
        {
          "exchange": "NSE",
          "script": "DLF26MARFUT",
          "type": "buy",
          "quantity": 12000.00,
          "price": 605.700000,
        },
        {
           "exchange": "NSE",
           "script": "RBLBANK26MARFUT",
           "type": "buy",
           "quantity": 30000.00,
           "price": 321.550000,
        },
        {
           "exchange": "NSE",
           "script": "VEDL26MARFUT",
           "type": "buy",
           "quantity": 12000.00,
           "price": 720.200000,
        }
      ],
      "exchangeWisePL": [
        {
          "exchange": "NSE",
          "mtm": 496445.00,
          "brok": 93600.10,
          "pl": 402844.90,
        }
      ]
    };
    try {
      return BillGenerateReportModel.fromJson(mockResponse);
    } catch (e) {
      throw ServerException('Data parsing error: $e');
    }
  }
}
