import 'package:equatable/equatable.dart';

class RejectionLog extends Equatable {
  final String id;
  final DateTime orderDateTime;
  final String status;
  final String userName;
  final String symbol;
  final String exchange;
  final String type;
  final double qty;
  final double price;
  final String comment;
  final String deviceId;
  final String device;
  final String city;
  final String ipAddress;
  final DateTime date;
  const RejectionLog({
    required this.id,
    required this.orderDateTime,
    required this.status,
    required this.userName,
    required this.symbol,
    required this.exchange,
    required this.type,
    required this.qty,
    required this.price,
    required this.comment,
    required this.deviceId,
    required this.device,
    required this.city,
    required this.ipAddress,
    required this.date,
  });
  @override
  List<Object?> get props => [
    id,
    orderDateTime,
    status,
    userName,
    symbol,
    exchange,
    type,
    qty,
    price,
    comment,
    deviceId,
    device,
    city,
    ipAddress,
    date,
  ];
  RejectionLog copyWith({
    String? id,
    DateTime? orderDateTime,
    String? status,
    String? userName,
    String? symbol,
    String? exchange,
    String? type,
    double? qty,
    double? price,
    String? comment,
    String? deviceId,
    String? device,
    String? city,
    String? ipAddress,
    DateTime? date,
  }) {
    return RejectionLog(
      id: id ?? this.id,
      orderDateTime: orderDateTime ?? this.orderDateTime,
      status: status ?? this.status,
      userName: userName ?? this.userName,
      symbol: symbol ?? this.symbol,
      exchange: exchange ?? this.exchange,
      type: type ?? this.type,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      comment: comment ?? this.comment,
      deviceId: deviceId ?? this.deviceId,
      device: device ?? this.device,
      city: city ?? this.city,
      ipAddress: ipAddress ?? this.ipAddress,
      date: date ?? this.date,
    );
  }
}
