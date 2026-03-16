import 'package:equatable/equatable.dart';

class PendingOrder extends Equatable {
  final String id;
  final String userId;
  final String upline;
  final String exchange;
  final String symbol;
  final String buySell;
  final double qty;
  final double lot;
  final double triggerPrice;
  final DateTime orderDateTime;
  final DateTime modifyOrderDateTime;
  final String orderType;
  final double cmp;
  final double rPrice;
  final String? deviceId;
  final String? ipAddress;
  const PendingOrder({
    required this.id,
    required this.userId,
    required this.upline,
    required this.exchange,
    required this.symbol,
    required this.buySell,
    required this.qty,
    required this.lot,
    required this.triggerPrice,
    required this.orderDateTime,
    required this.modifyOrderDateTime,
    required this.orderType,
    required this.cmp,
    required this.rPrice,
    this.deviceId,
    this.ipAddress,
  });
  bool get isBuy => buySell.toUpperCase().startsWith('BUY');
  bool get isSell => buySell.toUpperCase().startsWith('SELL');
  @override
  List<Object?> get props => [
    id,
    userId,
    upline,
    exchange,
    symbol,
    buySell,
    qty,
    lot,
    triggerPrice,
    orderDateTime,
    modifyOrderDateTime,
    orderType,
    cmp,
    rPrice,
    deviceId,
    ipAddress,
  ];
}
