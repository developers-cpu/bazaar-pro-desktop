import '../../../domain/entities/deleted_trade/deleted_trade.dart';
class DeletedTradeModel extends DeletedTrade {
  const DeletedTradeModel({
    required super.id,
    required super.userName,
    required super.parentUser,
    required super.exchange,
    required super.symbol,
    required super.orderDateTime,
    required super.buySell,
    required super.qty,
    required super.lot,
    required super.type,
    required super.pl,
    required super.tradePrice,
    required super.brokerage,
    required super.ratePrice,
    required super.executionDateTime,
    required super.deviceId,
    required super.city,
    required super.device,
    required super.ipAddress,
  });
  factory DeletedTradeModel.fromJson(Map<String, dynamic> json) {
    return DeletedTradeModel(
      id: json['id']?.toString() ?? '',
      userName: json['u_name'] ?? json['userName'] ?? '',
      parentUser: json['p_user'] ?? json['parentUser'] ?? '',
      exchange: json['exchange'] ?? json['exch'] ?? '',
      symbol: json['symbol'] ?? '',
      orderDateTime: json['orderDateTime'] != null
          ? DateTime.parse(json['orderDateTime'])
          : DateTime.now(),
      buySell: json['buySell'] ?? json['bs'] ?? '',
      qty: (json['qty'] ?? 0).toDouble(),
      lot: (json['lot'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      pl: (json['pl'] ?? 0).toDouble(),
      tradePrice: (json['tradePrice'] ?? json['t_price'] ?? 0).toDouble(),
      brokerage: (json['brokerage'] ?? json['brk'] ?? 0).toDouble(),
      ratePrice: (json['ratePrice'] ?? json['r_price'] ?? 0).toDouble(),
      executionDateTime: json['executionDateTime'] != null
          ? DateTime.parse(json['executionDateTime'])
          : DateTime.now(),
      deviceId: json['deviceId'] ?? json['device_id'] ?? '',
      city: json['city'] ?? '',
      device: json['device'] ?? '',
      ipAddress: json['ipAddress'] ?? json['ip_address'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'parentUser': parentUser,
      'exchange': exchange,
      'symbol': symbol,
      'orderDateTime': orderDateTime.toIso8601String(),
      'buySell': buySell,
      'qty': qty,
      'lot': lot,
      'type': type,
      'pl': pl,
      'tradePrice': tradePrice,
      'brokerage': brokerage,
      'ratePrice': ratePrice,
      'executionDateTime': executionDateTime.toIso8601String(),
      'deviceId': deviceId,
      'city': city,
      'device': device,
      'ipAddress': ipAddress,
    };
  }
  factory DeletedTradeModel.fromEntity(DeletedTrade trade) {
    return DeletedTradeModel(
      id: trade.id,
      userName: trade.userName,
      parentUser: trade.parentUser,
      exchange: trade.exchange,
      symbol: trade.symbol,
      orderDateTime: trade.orderDateTime,
      buySell: trade.buySell,
      qty: trade.qty,
      lot: trade.lot,
      type: trade.type,
      pl: trade.pl,
      tradePrice: trade.tradePrice,
      brokerage: trade.brokerage,
      ratePrice: trade.ratePrice,
      executionDateTime: trade.executionDateTime,
      deviceId: trade.deviceId,
      city: trade.city,
      device: trade.device,
      ipAddress: trade.ipAddress,
    );
  }
}
