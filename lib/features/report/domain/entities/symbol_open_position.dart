import 'package:equatable/equatable.dart';

class SymbolOpenPosition extends Equatable {
  final String name;
  final String type;
  final String exchange;
  final String symbol;
  final double buyQty;
  final double sellQty;
  final double netQty;
  final double netAvgPrice;
  final double cmp;
  final double m2m;
  final double ourPercent;
  final String user;
  final int days;

  const SymbolOpenPosition({
    required this.name,
    required this.type,
    required this.exchange,
    required this.symbol,
    required this.buyQty,
    required this.sellQty,
    required this.netQty,
    required this.netAvgPrice,
    required this.cmp,
    required this.m2m,
    required this.ourPercent,
    required this.user,
    required this.days,
  });

  @override
  List<Object?> get props => [
    name,
    type,
    exchange,
    symbol,
    buyQty,
    sellQty,
    netQty,
    netAvgPrice,
    cmp,
    m2m,
    ourPercent,
    user,
    days,
  ];
}
