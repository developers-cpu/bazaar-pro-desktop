import '../../../domain/entities/deals/deals.dart';

/// Deal model
class DealModel extends Deal {
  const DealModel({
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
    required super.orderDuration,
    required super.status,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(
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
      orderDuration: json['orderDuration'] ?? '0 hours 0 minutes',
      status: json['status'] ?? 'Market',
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
      'orderDuration': orderDuration,
      'status': status,
    };
  }

  /// Create from entity
  factory DealModel.fromEntity(Deal deal) {
    return DealModel(
      id: deal.id,
      userName: deal.userName,
      pUser: deal.pUser,
      exchange: deal.exchange,
      symbol: deal.symbol,
      orderDateTime: deal.orderDateTime,
      buySell: deal.buySell,
      qty: deal.qty,
      lot: deal.lot,
      orderType: deal.orderType,
      pl: deal.pl,
      triggerPrice: deal.triggerPrice,
      brokerage: deal.brokerage,
      rPrice: deal.rPrice,
      executionDateTime: deal.executionDateTime,
      deviceId: deal.deviceId,
      ipAddress: deal.ipAddress,
      orderDuration: deal.orderDuration,
      status: deal.status,
    );
  }
}