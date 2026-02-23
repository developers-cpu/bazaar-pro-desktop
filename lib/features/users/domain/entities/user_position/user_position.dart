import 'package:equatable/equatable.dart';
class UserPosition extends Equatable {
  final String exchange;
  final String symbol;
  final double buyQty;
  final double sellQty;
  final double netQty;
  final double netAp;
  final double cmp;
  final double m2m;
  final double lot;
  const UserPosition({
    required this.exchange,
    required this.symbol,
    required this.buyQty,
    required this.sellQty,
    required this.netQty,
    required this.netAp,
    required this.cmp,
    required this.m2m,
    required this.lot,
  });
  @override
  List<Object?> get props => [
    exchange,
    symbol,
    buyQty,
    sellQty,
    netQty,
    netAp,
    cmp,
    m2m,
    lot,
  ];
}
