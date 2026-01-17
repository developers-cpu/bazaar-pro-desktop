import '../../domain/entities/trade.dart';

/// Trade model for data layer
class TradeModel extends Trade {
  const TradeModel({
    required super.id,
    required super.userName,
    required super.pUser,
    required super.exchange,
    required super.symbol,
    required super.orderDateTime,
    required super.buySell,
    required super.qty,
    required super.lot,
    required super.orderType,
    required super.pl,
    required super.triggerPrice,
    required super.brokerage,
    required super.rPrice,
    super.executionDateTime,
    super.deviceId,
    super.ipAddress,
  });

  factory TradeModel.fromJson(Map<String, dynamic> json) {
    return TradeModel(
      id: json['id']?.toString() ?? '',
      userName: json['userName'] ?? json['u_name'] ?? '',
      pUser: json['pUser'] ?? json['p_user'] ?? '',
      exchange: json['exchange'] ?? json['exch'] ?? '',
      symbol: json['symbol'] ?? '',
      orderDateTime: json['orderDateTime'] != null
          ? DateTime.parse(json['orderDateTime'])
          : DateTime.now(),
      buySell: json['buySell'] ?? json['bs'] ?? '',
      qty: (json['qty'] ?? 0).toDouble(),
      lot: (json['lot'] ?? 0).toDouble(),
      orderType: json['orderType'] ?? json['type'] ?? '',
      pl: (json['pl'] ?? 0).toDouble(),
      triggerPrice: (json['triggerPrice'] ?? json['t_price'] ?? 0).toDouble(),
      brokerage: (json['brokerage'] ?? json['brk'] ?? 0).toDouble(),
      rPrice: (json['rPrice'] ?? json['r_price'] ?? 0).toDouble(),
      executionDateTime: json['executionDateTime'] != null
          ? DateTime.parse(json['executionDateTime'])
          : null,
      deviceId: json['deviceId'],
      ipAddress: json['ipAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'pUser': pUser,
      'exchange': exchange,
      'symbol': symbol,
      'orderDateTime': orderDateTime.toIso8601String(),
      'buySell': buySell,
      'qty': qty,
      'lot': lot,
      'orderType': orderType,
      'pl': pl,
      'triggerPrice': triggerPrice,
      'brokerage': brokerage,
      'rPrice': rPrice,
      'executionDateTime': executionDateTime?.toIso8601String(),
      'deviceId': deviceId,
      'ipAddress': ipAddress,
    };
  }

  /// Create from entity
  factory TradeModel.fromEntity(Trade trade) {
    return TradeModel(
      id: trade.id,
      userName: trade.userName,
      pUser: trade.pUser,
      exchange: trade.exchange,
      symbol: trade.symbol,
      orderDateTime: trade.orderDateTime,
      buySell: trade.buySell,
      qty: trade.qty,
      lot: trade.lot,
      orderType: trade.orderType,
      pl: trade.pl,
      triggerPrice: trade.triggerPrice,
      brokerage: trade.brokerage,
      rPrice: trade.rPrice,
      executionDateTime: trade.executionDateTime,
      deviceId: trade.deviceId,
      ipAddress: trade.ipAddress,
    );
  }
}