import 'package:equatable/equatable.dart';

class UserPendingOrder extends Equatable {
  final String id;
  // Add fields as needed, currently placeholder based on typical order data
  final String exchange;
  final String symbol;
  final String orderType;
  final double price;
  final int qty;

  const UserPendingOrder({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.orderType,
    required this.price,
    required this.qty,
  });

  @override
  List<Object?> get props => [id, exchange, symbol, orderType, price, qty];
}
