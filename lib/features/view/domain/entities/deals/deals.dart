import 'package:equatable/equatable.dart';

class Deal extends Equatable {
  final String id;
  final String userName;
  final String pUser;
  final String exchange;
  final String symbol;
  final DateTime orderDateTime;
  final String buySell;
  final double qty;
  final double lot;
  final String orderType;
  final double pl;
  final double triggerPrice;
  final double brokerage;
  final double rPrice;
  final DateTime? executionDateTime;
  final String? deviceId;
  final String? device;
  final String? city;
  final String? ipAddress;
  final String orderDuration;
  final String status;
  const Deal({
    required this.id,
    required this.userName,
    required this.pUser,
    required this.exchange,
    required this.symbol,
    required this.orderDateTime,
    required this.buySell,
    required this.qty,
    required this.lot,
    required this.orderType,
    required this.pl,
    required this.triggerPrice,
    required this.brokerage,
    required this.rPrice,
    this.executionDateTime,
    this.deviceId,
    this.device,
    this.city,
    this.ipAddress,
    required this.orderDuration,
    required this.status,
  });
  @override
  List<Object?> get props => [
    id,
    userName,
    pUser,
    exchange,
    symbol,
    orderDateTime,
    buySell,
    qty,
    lot,
    orderType,
    pl,
    triggerPrice,
    brokerage,
    rPrice,
    executionDateTime,
    deviceId,
    device,
    city,
    ipAddress,
    orderDuration,
    status,
  ];
  Deal copyWith({
    String? id,
    String? userName,
    String? pUser,
    String? exchange,
    String? symbol,
    DateTime? orderDateTime,
    String? buySell,
    double? qty,
    double? lot,
    String? orderType,
    double? pl,
    double? triggerPrice,
    double? brokerage,
    double? rPrice,
    DateTime? executionDateTime,
    String? deviceId,
    String? device,
    String? city,
    String? ipAddress,
    String? orderDuration,
    String? status,
  }) {
    return Deal(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      pUser: pUser ?? this.pUser,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      orderDateTime: orderDateTime ?? this.orderDateTime,
      buySell: buySell ?? this.buySell,
      qty: qty ?? this.qty,
      lot: lot ?? this.lot,
      orderType: orderType ?? this.orderType,
      pl: pl ?? this.pl,
      triggerPrice: triggerPrice ?? this.triggerPrice,
      brokerage: brokerage ?? this.brokerage,
      rPrice: rPrice ?? this.rPrice,
      executionDateTime: executionDateTime ?? this.executionDateTime,
      deviceId: deviceId ?? this.deviceId,
      device: device ?? this.device,
      city: city ?? this.city,
      ipAddress: ipAddress ?? this.ipAddress,
      orderDuration: orderDuration ?? this.orderDuration,
      status: status ?? this.status,
    );
  }
}
