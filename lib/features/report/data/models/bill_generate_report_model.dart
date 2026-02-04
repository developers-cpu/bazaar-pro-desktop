import '../../domain/entities/bill_generate_report.dart';

class BillGenerateReportModel extends BillGenerateReport {
  const BillGenerateReportModel({
    required BillHeaderInfoModel headerInfo,
    required List<ExchangeBillReportModel> exchangeReports,
    required List<ScriptBillSummaryModel> scriptWiseSummary,
    required BillTotalModel overallTotal,
  }) : super(
         headerInfo: headerInfo,
         exchangeReports: exchangeReports,
         scriptWiseSummary: scriptWiseSummary,
         overallTotal: overallTotal,
       );

  factory BillGenerateReportModel.fromJson(Map<String, dynamic> json) {
    return BillGenerateReportModel(
      headerInfo: BillHeaderInfoModel.fromJson(json['headerInfo']),
      exchangeReports: (json['exchangeReports'] as List)
          .map((e) => ExchangeBillReportModel.fromJson(e))
          .toList(),
      scriptWiseSummary: (json['scriptWiseSummary'] as List)
          .map((e) => ScriptBillSummaryModel.fromJson(e))
          .toList(),
      overallTotal: BillTotalModel.fromJson(json['overallTotal']),
    );
  }
}

class BillHeaderInfoModel extends BillHeaderInfo {
  const BillHeaderInfoModel({
    required String userName,
    required String dateRange,
    required String billNo,
  }) : super(userName: userName, dateRange: dateRange, billNo: billNo);

  factory BillHeaderInfoModel.fromJson(Map<String, dynamic> json) {
    return BillHeaderInfoModel(
      userName: json['userName'] ?? '',
      dateRange: json['dateRange'] ?? '',
      billNo: json['billNo'] ?? '',
    );
  }
}

class ExchangeBillReportModel extends ExchangeBillReport {
  const ExchangeBillReportModel({
    required String exchangeName,
    required List<BillTradeDetailModel> trades,
    required BillExchangeTotalModel total,
  }) : super(exchangeName: exchangeName, trades: trades, total: total);

  factory ExchangeBillReportModel.fromJson(Map<String, dynamic> json) {
    return ExchangeBillReportModel(
      exchangeName: json['exchangeName'] ?? '',
      trades: (json['trades'] as List)
          .map((e) => BillTradeDetailModel.fromJson(e))
          .toList(),
      total: BillExchangeTotalModel.fromJson(json['total']),
    );
  }
}

class BillTradeDetailModel extends BillTradeDetail {
  const BillTradeDetailModel({
    required String exchange,
    required String script,
    int? buyQty,
    double? buyPrice,
    int? sellQty,
    double? sellPrice,
    required double brokerage,
    required double profitLoss,
  }) : super(
         exchange: exchange,
         script: script,
         buyQty: buyQty,
         buyPrice: buyPrice,
         sellQty: sellQty,
         sellPrice: sellPrice,
         brokerage: brokerage,
         profitLoss: profitLoss,
       );

  factory BillTradeDetailModel.fromJson(Map<String, dynamic> json) {
    return BillTradeDetailModel(
      exchange: json['exchange'] ?? '',
      script: json['script'] ?? '',
      buyQty: json['buyQty'],
      buyPrice: (json['buyPrice'] as num?)?.toDouble(),
      sellQty: json['sellQty'],
      sellPrice: (json['sellPrice'] as num?)?.toDouble(),
      brokerage: (json['brokerage'] as num?)?.toDouble() ?? 0.0,
      profitLoss: (json['profitLoss'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class BillExchangeTotalModel extends BillExchangeTotal {
  const BillExchangeTotalModel({
    required int totalBuyQty,
    required int totalSellQty,
    required double totalBrokerage,
    required double totalProfitLoss,
  }) : super(
         totalBuyQty: totalBuyQty,
         totalSellQty: totalSellQty,
         totalBrokerage: totalBrokerage,
         totalProfitLoss: totalProfitLoss,
       );

  factory BillExchangeTotalModel.fromJson(Map<String, dynamic> json) {
    return BillExchangeTotalModel(
      totalBuyQty: json['totalBuyQty'] ?? 0,
      totalSellQty: json['totalSellQty'] ?? 0,
      totalBrokerage: (json['totalBrokerage'] as num?)?.toDouble() ?? 0.0,
      totalProfitLoss: (json['totalProfitLoss'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ScriptBillSummaryModel extends ScriptBillSummary {
  const ScriptBillSummaryModel({
    required String exchange,
    required String script,
    required double mtm,
    required double brokerage,
    required double netAmount,
  }) : super(
         exchange: exchange,
         script: script,
         mtm: mtm,
         brokerage: brokerage,
         netAmount: netAmount,
       );

  factory ScriptBillSummaryModel.fromJson(Map<String, dynamic> json) {
    return ScriptBillSummaryModel(
      exchange: json['exchange'] ?? '',
      script: json['script'] ?? '',
      mtm: (json['mtm'] as num?)?.toDouble() ?? 0.0,
      brokerage: (json['brokerage'] as num?)?.toDouble() ?? 0.0,
      netAmount: (json['netAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class BillTotalModel extends BillTotal {
  const BillTotalModel({
    required double totalMtm,
    required double totalBrokerage,
    required double totalNetAmount,
  }) : super(
         totalMtm: totalMtm,
         totalBrokerage: totalBrokerage,
         totalNetAmount: totalNetAmount,
       );

  factory BillTotalModel.fromJson(Map<String, dynamic> json) {
    return BillTotalModel(
      totalMtm: (json['totalMtm'] as num?)?.toDouble() ?? 0.0,
      totalBrokerage: (json['totalBrokerage'] as num?)?.toDouble() ?? 0.0,
      totalNetAmount: (json['totalNetAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
