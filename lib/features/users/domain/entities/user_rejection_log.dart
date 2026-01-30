import 'package:equatable/equatable.dart';

class UserRejectionLog extends Equatable {
  final String id;
  final DateTime dateTime;
  final String status;
  final String userName;
  final String exchange;
  final String symbol;
  final String type; // BUY / SELL
  final int qty;
  final double price;
  final String comment;

  const UserRejectionLog({
    required this.id,
    required this.dateTime,
    required this.status,
    required this.userName,
    required this.exchange,
    required this.symbol,
    required this.type,
    required this.qty,
    required this.price,
    required this.comment,
  });

  @override
  List<Object?> get props => [
    id,
    dateTime,
    status,
    userName,
    exchange,
    symbol,
    type,
    qty,
    price,
    comment,
  ];
}
