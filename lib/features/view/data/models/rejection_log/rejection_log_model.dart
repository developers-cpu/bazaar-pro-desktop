import '../../../domain/entities/rejection_log/rejection_log.dart';
class RejectionLogModel extends RejectionLog {
  const RejectionLogModel({
    required super.id,
    required super.orderDateTime,
    required super.userName,
    required super.symbol,
    required super.type,
    required super.qty,
    required super.price,
    required super.comment,
    required super.date,
  });
  factory RejectionLogModel.fromJson(Map<String, dynamic> json) {
    return RejectionLogModel(
      id: json['id']?.toString() ?? '',
      orderDateTime: json['orderDateTime'] != null
          ? DateTime.parse(json['orderDateTime'])
          : DateTime.now(),
      userName: json['userName'] ?? json['u_name'] ?? '',
      symbol: json['symbol'] ?? '',
      type: json['type'] ?? '',
      qty: (json['qty'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDateTime': orderDateTime.toIso8601String(),
      'userName': userName,
      'symbol': symbol,
      'type': type,
      'qty': qty,
      'price': price,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
  factory RejectionLogModel.fromEntity(RejectionLog log) {
    return RejectionLogModel(
      id: log.id,
      orderDateTime: log.orderDateTime,
      userName: log.userName,
      symbol: log.symbol,
      type: log.type,
      qty: log.qty,
      price: log.price,
      comment: log.comment,
      date: log.date,
    );
  }
}
