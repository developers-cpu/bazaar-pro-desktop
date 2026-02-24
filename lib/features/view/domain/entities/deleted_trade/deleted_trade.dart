import 'package:equatable/equatable.dart';

class DeletedTrade extends Equatable {
  final String id;
  final String userName;
  final String parentUser;
  final String exchange;
  final String symbol;
  final DateTime orderDateTime;
  final String buySell;
  final double qty;
  final double lot;
  final String type;
  final double pl;
  final double tradePrice;
  final double brokerage;
  final double ratePrice;
  final DateTime executionDateTime;
  final String deviceId;
  final String city;
  final String device;
  final String ipAddress;

  const DeletedTrade({
    required this.id,
    required this.userName,
    required this.parentUser,
    required this.exchange,
    required this.symbol,
    required this.orderDateTime,
    required this.buySell,
    required this.qty,
    required this.lot,
    required this.type,
    required this.pl,
    required this.tradePrice,
    required this.brokerage,
    required this.ratePrice,
    required this.executionDateTime,
    required this.deviceId,
    required this.city,
    required this.device,
    required this.ipAddress,
  });

  @override
  List<Object?> get props => [
    id,
    userName,
    parentUser,
    exchange,
    symbol,
    orderDateTime,
    buySell,
    qty,
    lot,
    type,
    pl,
    tradePrice,
    brokerage,
    ratePrice,
    executionDateTime,
    deviceId,
    city,
    device,
    ipAddress,
  ];

  DeletedTrade copyWith({
    String? id,
    String? userName,
    String? parentUser,
    String? exchange,
    String? symbol,
    DateTime? orderDateTime,
    String? buySell,
    double? qty,
    double? lot,
    String? type,
    double? pl,
    double? tradePrice,
    double? brokerage,
    double? ratePrice,
    DateTime? executionDateTime,
    String? deviceId,
    String? city,
    String? device,
    String? ipAddress,
  }) {
    return DeletedTrade(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      parentUser: parentUser ?? this.parentUser,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      orderDateTime: orderDateTime ?? this.orderDateTime,
      buySell: buySell ?? this.buySell,
      qty: qty ?? this.qty,
      lot: lot ?? this.lot,
      type: type ?? this.type,
      pl: pl ?? this.pl,
      tradePrice: tradePrice ?? this.tradePrice,
      brokerage: brokerage ?? this.brokerage,
      ratePrice: ratePrice ?? this.ratePrice,
      executionDateTime: executionDateTime ?? this.executionDateTime,
      deviceId: deviceId ?? this.deviceId,
      city: city ?? this.city,
      device: device ?? this.device,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}
