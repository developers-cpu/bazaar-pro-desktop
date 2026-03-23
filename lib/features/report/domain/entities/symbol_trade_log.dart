import 'package:equatable/equatable.dart';

class SymbolTradeLog extends Equatable {
  final String sequence;
  final String userName;
  final String pUser;
  final String exchange;
  final String symbol;
  final String buySell;
  final String tradeType;
  final double qty;
  final double lot;
  final double pl;
  final String validity;
  final double tradePrice;
  final double brokerage;
  final double netPrice;
  final String orderDateTime;
  final String executionDateTime;
  final double referencePrice;
  const SymbolTradeLog({
    required this.sequence,
    required this.userName,
    required this.pUser,
    required this.exchange,
    required this.symbol,
    required this.buySell,
    required this.tradeType,
    required this.qty,
    required this.lot,
    required this.pl,
    required this.validity,
    required this.tradePrice,
    required this.brokerage,
    required this.netPrice,
    required this.orderDateTime,
    required this.executionDateTime,
    required this.referencePrice,
  });
  @override
  List<Object?> get props => [
    sequence,
    userName,
    pUser,
    exchange,
    symbol,
    buySell,
    tradeType,
    qty,
    lot,
    pl,
    validity,
    tradePrice,
    brokerage,
    netPrice,
    orderDateTime,
    executionDateTime,
    referencePrice,
  ];
}
