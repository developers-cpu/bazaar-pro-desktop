import '../../domain/entities/bill_generate_report.dart';
class BillGenerateReportModel extends BillGenerateReport {
  const BillGenerateReportModel({
    required BillHeaderInfoModel headerInfo,
    required List<BillScriptTradeModel> scriptTrades,
    required List<ScriptBillSummaryModel> scriptWiseSummary,
    required BillTotalModel summaryTotal,
    required List<CarryForwardTradeModel> carryForward,
    required List<ExchangeWisePLModel> exchangeWisePL,
  }) : super(
         headerInfo: headerInfo,
         scriptTrades: scriptTrades,
         scriptWiseSummary: scriptWiseSummary,
         summaryTotal: summaryTotal,
         carryForward: carryForward,
         exchangeWisePL: exchangeWisePL,
       );
  factory BillGenerateReportModel.fromJson(Map<String, dynamic> json) {
    return BillGenerateReportModel(
      headerInfo: BillHeaderInfoModel.fromJson(json['headerInfo']),
      scriptTrades:
          (json['scriptTrades'] as List?)
              ?.map((e) => BillScriptTradeModel.fromJson(e))
              .toList() ??
          [],
      scriptWiseSummary:
          (json['scriptWiseSummary'] as List?)
              ?.map((e) => ScriptBillSummaryModel.fromJson(e))
              .toList() ??
          [],
      summaryTotal: BillTotalModel.fromJson(json['summaryTotal']),
      carryForward:
          (json['carryForward'] as List?)
              ?.map((e) => CarryForwardTradeModel.fromJson(e))
              .toList() ??
          [],
      exchangeWisePL:
          (json['exchangeWisePL'] as List?)
              ?.map((e) => ExchangeWisePLModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
class BillHeaderInfoModel extends BillHeaderInfo {
  const BillHeaderInfoModel({
    required String userName,
    required String dateRange,
  }) : super(userName: userName, dateRange: dateRange);
  factory BillHeaderInfoModel.fromJson(Map<String, dynamic> json) {
    return BillHeaderInfoModel(
      userName: json['userName'] ?? '',
      dateRange: json['dateRange'] ?? '',
    );
  }
}
class BillScriptTradeModel extends BillScriptTrade {
  const BillScriptTradeModel({
    required String exchange,
    required String script,
    required List<BillTradeLegModel> buyLegs,
    required List<BillTradeLegModel> sellLegs,
    required int totalBuyQty,
    required double totalBuyVol,
    required int totalSellQty,
    required double totalSellVol,
    required double netDifference,
    required double brokerage,
    required double profitLoss,
  }) : super(
         exchange: exchange,
         script: script,
         buyLegs: buyLegs,
         sellLegs: sellLegs,
         totalBuyQty: totalBuyQty,
         totalBuyVol: totalBuyVol,
         totalSellQty: totalSellQty,
         totalSellVol: totalSellVol,
         netDifference: netDifference,
         brokerage: brokerage,
         profitLoss: profitLoss,
       );
  factory BillScriptTradeModel.fromJson(Map<String, dynamic> json) {
    return BillScriptTradeModel(
      exchange: json['exchange'] ?? '',
      script: json['script'] ?? '',
      buyLegs:
          (json['buyLegs'] as List?)
              ?.map((e) => BillTradeLegModel.fromJson(e))
              .toList() ??
          [],
      sellLegs:
          (json['sellLegs'] as List?)
              ?.map((e) => BillTradeLegModel.fromJson(e))
              .toList() ??
          [],
      totalBuyQty: json['totalBuyQty'] ?? 0,
      totalBuyVol: (json['totalBuyVol'] as num?)?.toDouble() ?? 0.0,
      totalSellQty: json['totalSellQty'] ?? 0,
      totalSellVol: (json['totalSellVol'] as num?)?.toDouble() ?? 0.0,
      netDifference: (json['netDifference'] as num?)?.toDouble() ?? 0.0,
      brokerage: (json['brokerage'] as num?)?.toDouble() ?? 0.0,
      profitLoss: (json['profitLoss'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
class BillTradeLegModel extends BillTradeLeg {
  const BillTradeLegModel({
    required String date,
    required int qty,
    required String price,
    required double vol,
  }) : super(date: date, qty: qty, price: price, vol: vol);
  factory BillTradeLegModel.fromJson(Map<String, dynamic> json) {
    return BillTradeLegModel(
      date: json['date'] ?? '',
      qty: json['qty'] ?? 0,
      price: json['price']?.toString() ?? '',
      vol: (json['vol'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
class ScriptBillSummaryModel extends ScriptBillSummary {
  const ScriptBillSummaryModel({
    required String exchange,
    required String script,
    required double total,
    required double brokerage,
    required double net,
  }) : super(
         exchange: exchange,
         script: script,
         total: total,
         brokerage: brokerage,
         net: net,
       );
  factory ScriptBillSummaryModel.fromJson(Map<String, dynamic> json) {
    return ScriptBillSummaryModel(
      exchange: json['exchange'] ?? '',
      script: json['script'] ?? '',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      brokerage: (json['brokerage'] as num?)?.toDouble() ?? 0.0,
      net: (json['net'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
class BillTotalModel extends BillTotal {
  const BillTotalModel({
    required double total,
    required double totalBrokerage,
    required double totalNet,
  }) : super(total: total, totalBrokerage: totalBrokerage, totalNet: totalNet);
  factory BillTotalModel.fromJson(Map<String, dynamic> json) {
    return BillTotalModel(
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      totalBrokerage: (json['totalBrokerage'] as num?)?.toDouble() ?? 0.0,
      totalNet: (json['totalNet'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
class CarryForwardTradeModel extends CarryForwardTrade {
  const CarryForwardTradeModel({
    required String exchange,
    required String script,
    required String type,
    required double quantity,
    required double price,
  }) : super(
         exchange: exchange,
         script: script,
         type: type,
         quantity: quantity,
         price: price,
       );
  factory CarryForwardTradeModel.fromJson(Map<String, dynamic> json) {
    return CarryForwardTradeModel(
      exchange: json['exchange'] ?? '',
      script: json['script'] ?? '',
      type: json['type'] ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
class ExchangeWisePLModel extends ExchangeWisePL {
  const ExchangeWisePLModel({
    required String exchange,
    required double mtm,
    required double brok,
    required double pl,
  }) : super(exchange: exchange, mtm: mtm, brok: brok, pl: pl);
  factory ExchangeWisePLModel.fromJson(Map<String, dynamic> json) {
    return ExchangeWisePLModel(
      exchange: json['exchange'] ?? '',
      mtm: (json['mtm'] as num?)?.toDouble() ?? 0.0,
      brok: (json['brok'] as num?)?.toDouble() ?? 0.0,
      pl: (json['pl'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
