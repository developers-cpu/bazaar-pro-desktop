import '../../../domain/entities/pending_orders/pending_order.dart';
class PendingOrderModel extends PendingOrder {
  const PendingOrderModel({
    required super.id,
    required super.userId,
    required super.upline,
    required super.exchange,
    required super.symbol,
    required super.buySell,
    required super.qty,
    required super.lot,
    required super.triggerPrice,
    required super.orderDateTime,
    required super.modifyOrderDateTime,
    required super.orderType,
    required super.cmp,
    required super.rPrice,
    super.deviceId,
    super.ipAddress,
  });
  factory PendingOrderModel.fromJson(Map<String, dynamic> json) {
    return PendingOrderModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? '',
      upline: json['upline'] ?? '',
      exchange: json['exchange'] ?? json['exch'] ?? '',
      symbol: json['symbol'] ?? '',
      buySell: json['buy_sell'] ?? json['buySell'] ?? json['b_s'] ?? '',
      qty: _parseDouble(json['qty']),
      lot: _parseDouble(json['lot']),
      triggerPrice: _parseDouble(json['trigger_price'] ?? json['t_price']),
      orderDateTime: _parseDateTime(json['order_dt'] ?? json['orderDateTime']),
      modifyOrderDateTime: _parseDateTime(
        json['modify_order_dt'] ?? json['modifyOrderDateTime'],
      ),
      orderType: json['order_type'] ?? json['type'] ?? 'Market',
      cmp: _parseDouble(json['cmp']),
      rPrice: _parseDouble(json['r_price'] ?? json['rPrice']),
      deviceId: json['device_id'] ?? json['deviceId'],
      ipAddress: json['ip_address'] ?? json['ipAddress'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'upline': upline,
      'exchange': exchange,
      'symbol': symbol,
      'buy_sell': buySell,
      'qty': qty,
      'lot': lot,
      'trigger_price': triggerPrice,
      'order_dt': orderDateTime.toIso8601String(),
      'modify_order_dt': modifyOrderDateTime.toIso8601String(),
      'order_type': orderType,
      'cmp': cmp,
      'r_price': rPrice,
      'device_id': deviceId,
      'ip_address': ipAddress,
    };
  }
  factory PendingOrderModel.fromEntity(PendingOrder entity) {
    return PendingOrderModel(
      id: entity.id,
      userId: entity.userId,
      upline: entity.upline,
      exchange: entity.exchange,
      symbol: entity.symbol,
      buySell: entity.buySell,
      qty: entity.qty,
      lot: entity.lot,
      triggerPrice: entity.triggerPrice,
      orderDateTime: entity.orderDateTime,
      modifyOrderDateTime: entity.modifyOrderDateTime,
      orderType: entity.orderType,
      cmp: entity.cmp,
      rPrice: entity.rPrice,
      deviceId: entity.deviceId,
      ipAddress: entity.ipAddress,
    );
  }
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
