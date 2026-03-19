import 'package:equatable/equatable.dart';

class TradeLog extends Equatable {
  final String id;
  final String userName;
  final String exchange;
  final String symbol;
  final String orderUpdateType;
  final String userType;
  final double oldQty;
  final double qty;
  final double oldPrice;
  final double price;
  final DateTime updateTime;
  final DateTime orderDateTime;
  final String modifyBy;
  const TradeLog({
    required this.id,
    required this.userName,
    required this.exchange,
    required this.symbol,
    required this.orderUpdateType,
    required this.userType,
    required this.oldQty,
    required this.qty,
    required this.oldPrice,
    required this.price,
    required this.updateTime,
    required this.orderDateTime,
    required this.modifyBy,
  });
  @override
  List<Object?> get props => [
    id,
    userName,
    exchange,
    symbol,
    orderUpdateType,
    userType,
    oldQty,
    qty,
    oldPrice,
    price,
    updateTime,
    orderDateTime,
    modifyBy,
  ];
}