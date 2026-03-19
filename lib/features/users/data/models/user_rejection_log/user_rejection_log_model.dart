import '../../../domain/entities/user_rejection_log/user_rejection_log.dart';

class UserRejectionLogModel extends UserRejectionLog {
  const UserRejectionLogModel({
    required super.id,
    required super.dateTime,
    required super.status,
    required super.userName,
    required super.exchange,
    required super.symbol,
    required super.type,
    required super.qty,
    required super.price,
    required super.comment,
  });
  factory UserRejectionLogModel.fromJson(Map<String, dynamic> json) {
    return UserRejectionLogModel(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      status: json['status'],
      userName: json['userName'],
      exchange: json['exchange'],
      symbol: json['symbol'],
      type: json['type'],
      qty: json['qty'] as int,
      price: (json['price'] as num).toDouble(),
      comment: json['comment'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'userName': userName,
      'exchange': exchange,
      'symbol': symbol,
      'type': type,
      'qty': qty,
      'price': price,
      'comment': comment,
    };
  }
}