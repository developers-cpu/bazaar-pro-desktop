import 'package:equatable/equatable.dart';

class UserTrade extends Equatable {
  final String id;
  final String userName;
  final String parentUser;
  final String exchange;
  final String symbol;
  final String buySell; // "BUY" or "SELL"
  final String tradeType; // "Market", "Limit"
  final double quantity;
  final double lot;
  final double profitLoss;
  final String validity;
  final double tradePrice;
  final double brokerage;
  final double netPrice;
  final DateTime orderTime;
  final DateTime executionTime;
  final double requestPrice;
  final String orderDuration;

  const UserTrade({
    required this.id,
    required this.userName,
    required this.parentUser,
    required this.exchange,
    required this.symbol,
    required this.buySell,
    required this.tradeType,
    required this.quantity,
    required this.lot,
    required this.profitLoss,
    required this.validity,
    required this.tradePrice,
    required this.brokerage,
    required this.netPrice,
    required this.orderTime,
    required this.executionTime,
    required this.requestPrice,
    required this.orderDuration,
  });

  @override
  List<Object?> get props => [
    id,
    userName,
    parentUser,
    exchange,
    symbol,
    buySell,
    tradeType,
    quantity,
    lot,
    profitLoss,
    validity,
    tradePrice,
    brokerage,
    netPrice,
    orderTime,
    executionTime,
    requestPrice,
    orderDuration,
  ];
}
