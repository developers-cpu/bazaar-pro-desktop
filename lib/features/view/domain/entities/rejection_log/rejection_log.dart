import 'package:equatable/equatable.dart';


class RejectionLog extends Equatable {
  final String id;
  final DateTime orderDateTime;
  final String userName;
  final String symbol;
  final String type;
  final double qty;
  final double price;
  final String comment;
  final DateTime date;

  const RejectionLog({
    required this.id,
    required this.orderDateTime,
    required this.userName,
    required this.symbol,
    required this.type,
    required this.qty,
    required this.price,
    required this.comment,
    required this.date,
  });

  @override
  List<Object?> get props => [
    id,
    orderDateTime,
    userName,
    symbol,
    type,
    qty,
    price,
    comment,
    date,
  ];

  RejectionLog copyWith({
    String? id,
    DateTime? orderDateTime,
    String? userName,
    String? symbol,
    String? type,
    double? qty,
    double? price,
    String? comment,
    DateTime? date,
  }) {
    return RejectionLog(
      id: id ?? this.id,
      orderDateTime: orderDateTime ?? this.orderDateTime,
      userName: userName ?? this.userName,
      symbol: symbol ?? this.symbol,
      type: type ?? this.type,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }
}