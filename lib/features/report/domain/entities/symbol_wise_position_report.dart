import 'package:equatable/equatable.dart';

class SymbolWisePositionReport extends Equatable {
  final String id;
  final String exchange;
  final String symbol;
  final double netQty;
  final double netMs;
  final double carryFwdQty;
  final double carryFwdMs;
  final double openQty;
  final double openMs;
  final double totalQty;
  final double totalMs;
  final double buyQty;
  final double buyMs;
  final double sellQty;
  final double sellMs;
  final double netAvgPrice;
  final double cmp;
  final double m2m;
  final double releasePL;
  final double netPL;
  final double brokerage;
  final double netPLWithBrokerage;
  const SymbolWisePositionReport({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.netQty,
    required this.netMs,
    required this.carryFwdQty,
    required this.carryFwdMs,
    required this.openQty,
    required this.openMs,
    required this.totalQty,
    required this.totalMs,
    required this.buyQty,
    required this.buyMs,
    required this.sellQty,
    required this.sellMs,
    required this.netAvgPrice,
    required this.cmp,
    required this.m2m,
    required this.releasePL,
    required this.netPL,
    required this.brokerage,
    required this.netPLWithBrokerage,
  });
  @override
  List<Object?> get props => [
    id,
    exchange,
    symbol,
    netQty,
    netMs,
    carryFwdQty,
    carryFwdMs,
    openQty,
    openMs,
    totalQty,
    totalMs,
    buyQty,
    buyMs,
    sellQty,
    sellMs,
    netAvgPrice,
    cmp,
    m2m,
    releasePL,
    netPL,
    brokerage,
    netPLWithBrokerage,
  ];
}
