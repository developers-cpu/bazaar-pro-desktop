import 'package:equatable/equatable.dart';

class UserPendingOrder extends Equatable {
  final String id;
  final DateTime time;
  final String symbol;
  final String exchange;
  final String type;
  final String lot;
  final double price;
  final String status;

  const UserPendingOrder({
    required this.id,
    required this.time,
    required this.symbol,
    required this.exchange,
    required this.type,
    required this.lot,
    required this.price,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    time,
    symbol,
    exchange,
    type,
    lot,
    price,
    status,
  ];
}
