import 'package:equatable/equatable.dart';

class BillGenerateReport extends Equatable {
  final BillHeaderInfo headerInfo;
  final List<BillScriptTrade> scriptTrades;
  final List<ScriptBillSummary> scriptWiseSummary;
  final BillTotal summaryTotal;
  final List<CarryForwardTrade> carryForward;
  final List<ExchangeWisePL> exchangeWisePL;
  const BillGenerateReport({
    required this.headerInfo,
    required this.scriptTrades,
    required this.scriptWiseSummary,
    required this.summaryTotal,
    required this.carryForward,
    required this.exchangeWisePL,
  });
  @override
  List<Object?> get props => [
    headerInfo,
    scriptTrades,
    scriptWiseSummary,
    summaryTotal,
    carryForward,
    exchangeWisePL,
  ];
}

class BillHeaderInfo extends Equatable {
  final String userName;
  final String dateRange;
  const BillHeaderInfo({required this.userName, required this.dateRange});
  @override
  List<Object?> get props => [userName, dateRange];
}

class BillScriptTrade extends Equatable {
  final String exchange;
  final String script;
  final List<BillTradeLeg> buyLegs;
  final List<BillTradeLeg> sellLegs;
  final int totalBuyQty;
  final double totalBuyVol;
  final int totalSellQty;
  final double totalSellVol;
  final double netDifference;
  final double brokerage;
  final double profitLoss;
  const BillScriptTrade({
    required this.exchange,
    required this.script,
    required this.buyLegs,
    required this.sellLegs,
    required this.totalBuyQty,
    required this.totalBuyVol,
    required this.totalSellQty,
    required this.totalSellVol,
    required this.netDifference,
    required this.brokerage,
    required this.profitLoss,
  });
  @override
  List<Object?> get props => [
    exchange,
    script,
    buyLegs,
    sellLegs,
    totalBuyQty,
    totalBuyVol,
    totalSellQty,
    totalSellVol,
    netDifference,
    brokerage,
    profitLoss,
  ];
}

class BillTradeLeg extends Equatable {
  final String date;
  final int qty;
  final String price;
  final double vol;
  const BillTradeLeg({
    required this.date,
    required this.qty,
    required this.price,
    required this.vol,
  });
  @override
  List<Object?> get props => [date, qty, price, vol];
}

class ScriptBillSummary extends Equatable {
  final String exchange;
  final String script;
  final double total;
  final double brokerage;
  final double net;
  const ScriptBillSummary({
    required this.exchange,
    required this.script,
    required this.total,
    required this.brokerage,
    required this.net,
  });
  @override
  List<Object?> get props => [exchange, script, total, brokerage, net];
}

class BillTotal extends Equatable {
  final double total;
  final double totalBrokerage;
  final double totalNet;
  const BillTotal({
    required this.total,
    required this.totalBrokerage,
    required this.totalNet,
  });
  @override
  List<Object?> get props => [total, totalBrokerage, totalNet];
}

class CarryForwardTrade extends Equatable {
  final String exchange;
  final String script;
  final String type;
  final double quantity;
  final double price;
  const CarryForwardTrade({
    required this.exchange,
    required this.script,
    required this.type,
    required this.quantity,
    required this.price,
  });
  @override
  List<Object?> get props => [exchange, script, type, quantity, price];
}

class ExchangeWisePL extends Equatable {
  final String exchange;
  final double mtm;
  final double brok;
  final double pl;
  const ExchangeWisePL({
    required this.exchange,
    required this.mtm,
    required this.brok,
    required this.pl,
  });
  @override
  List<Object?> get props => [exchange, mtm, brok, pl];
}