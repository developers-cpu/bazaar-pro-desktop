import '../../../domain/entities/rejection_log/rejection_log.dart';

class RejectionLogModel extends RejectionLog {
  const RejectionLogModel({
    required super.id,
    required super.orderDateTime,
    required super.status,
    required super.userName,
    required super.symbol,
    required super.exchange,
    required super.type,
    required super.qty,
    required super.price,
    required super.comment,
    required super.deviceId,
    required super.device,
    required super.city,
    required super.ipAddress,
    required super.date,
  });
  factory RejectionLogModel.fromJson(Map<String, dynamic> json) {
    return RejectionLogModel(
      id: json['id']?.toString() ?? '',
      orderDateTime: json['orderDateTime'] != null
          ? DateTime.parse(json['orderDateTime'])
          : DateTime.now(),
      status: json['status'] ?? 'rejected',
      userName: json['userName'] ?? json['u_name'] ?? '',
      symbol: json['symbol'] ?? '',
      exchange: json['exchange'] ?? json['exch'] ?? '',
      type: json['type'] ?? '',
      qty: (json['qty'] ?? 0).toDouble().abs(),
      price: (json['price'] ?? 0).toDouble().abs(),
      comment: json['comment'] ?? '',
      deviceId: json['deviceId'] ?? json['device_id'] ?? '',
      device: json['device'] ?? '',
      city: json['city'] ?? '',
      ipAddress: json['ipAddress'] ?? json['ip_address'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDateTime': orderDateTime.toIso8601String(),
      'status': status,
      'userName': userName,
      'symbol': symbol,
      'exchange': exchange,
      'type': type,
      'qty': qty,
      'price': price,
      'comment': comment,
      'deviceId': deviceId,
      'device': device,
      'city': city,
      'ipAddress': ipAddress,
      'date': date.toIso8601String(),
    };
  }

  factory RejectionLogModel.fromEntity(RejectionLog log) {
    return RejectionLogModel(
      id: log.id,
      orderDateTime: log.orderDateTime,
      status: log.status,
      userName: log.userName,
      symbol: log.symbol,
      exchange: log.exchange,
      type: log.type,
      qty: log.qty,
      price: log.price,
      comment: log.comment,
      deviceId: log.deviceId,
      device: log.device,
      city: log.city,
      ipAddress: log.ipAddress,
      date: log.date,
    );
  }
}
