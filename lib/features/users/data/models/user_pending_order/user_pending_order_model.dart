import '../../../domain/entities/user_pending_order/user_pending_order.dart';
class UserPendingOrderModel extends UserPendingOrder {
  const UserPendingOrderModel({
    required super.id,
    required super.time,
    required super.symbol,
    required super.exchange,
    required super.type,
    required super.lot,
    required super.price,
    required super.status,
  });
  factory UserPendingOrderModel.fromJson(Map<String, dynamic> json) {
    return UserPendingOrderModel(
      id: json['id'],
      time: DateTime.parse(json['time']),
      symbol: json['symbol'],
      exchange: json['exchange'],
      type: json['type'],
      lot: json['lot'],
      price: (json['price'] as num).toDouble(),
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'symbol': symbol,
      'exchange': exchange,
      'type': type,
      'lot': lot,
      'price': price,
      'status': status,
    };
  }
}
