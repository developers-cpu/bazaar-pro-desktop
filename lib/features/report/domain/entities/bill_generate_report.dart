import 'package:equatable/equatable.dart';
class BillGenerateReport extends Equatable {
  final BillHeaderInfo headerInfo;
  final List<ExchangeBillReport> exchangeReports;
  final List<ScriptBillSummary> scriptWiseSummary;
  final BillTotal overallTotal;
  const BillGenerateReport({
    required this.headerInfo,
    required this.exchangeReports,
    required this.scriptWiseSummary,
    required this.overallTotal,
  });
  @override
  List<Object?> get props => [
    headerInfo,
    exchangeReports,
    scriptWiseSummary,
    overallTotal,
  ];
}
class BillHeaderInfo extends Equatable {
  final String userName;
  final String dateRange;
  final String billNo;
  const BillHeaderInfo({
    required this.userName,
    required this.dateRange,
    required this.billNo,
  });
  @override
  List<Object?> get props => [userName, dateRange, billNo];
}
class ExchangeBillReport extends Equatable {
  final String exchangeName;
  final List<BillTradeDetail> trades;
  final BillExchangeTotal total;
  const ExchangeBillReport({
    required this.exchangeName,
    required this.trades,
    required this.total,
  });
  @override
  List<Object?> get props => [exchangeName, trades, total];
}
class BillTradeDetail extends Equatable {
  final String exchange;
  final String script;
  final int? buyQty;
  final double? buyPrice;
  final int? sellQty;
  final double? sellPrice;
  final double brokerage;
  final double profitLoss;
  const BillTradeDetail({
    required this.exchange,
    required this.script,
    this.buyQty,
    this.buyPrice,
    this.sellQty,
    this.sellPrice,
    required this.brokerage,
    required this.profitLoss,
  });
  @override
  List<Object?> get props => [
    exchange,
    script,
    buyQty,
    buyPrice,
    sellQty,
    sellPrice,
    brokerage,
    profitLoss,
  ];
}
class BillExchangeTotal extends Equatable {
  final int totalBuyQty;
  final int totalSellQty;
  final double totalBrokerage;
  final double totalProfitLoss;
  const BillExchangeTotal({
    required this.totalBuyQty,
    required this.totalSellQty,
    required this.totalBrokerage,
    required this.totalProfitLoss,
  });
  @override
  List<Object?> get props => [
    totalBuyQty,
    totalSellQty,
    totalBrokerage,
    totalProfitLoss,
  ];
}
class ScriptBillSummary extends Equatable {
  final String exchange;
  final String script;
  final double mtm;
  final double brokerage;
  final double netAmount;
  const ScriptBillSummary({
    required this.exchange,
    required this.script,
    required this.mtm,
    required this.brokerage,
    required this.netAmount,
  });
  @override
  List<Object?> get props => [exchange, script, mtm, brokerage, netAmount];
}
class BillTotal extends Equatable {
  final double totalMtm;
  final double totalBrokerage;
  final double totalNetAmount;
  const BillTotal({
    required this.totalMtm,
    required this.totalBrokerage,
    required this.totalNetAmount,
  });
  @override
  List<Object?> get props => [totalMtm, totalBrokerage, totalNetAmount];
}
