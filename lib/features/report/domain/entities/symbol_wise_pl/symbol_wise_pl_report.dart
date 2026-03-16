import 'package:equatable/equatable.dart';
class SymbolWisePLReport extends Equatable {
  final String id;
  final String exchange;
  final String symbol;
  final double releasePL;
  final double m2m;
  final double brokerage;
  final double netPL;
  final double netQty;
  final double netQtyPercent;
  final double avgPrice;
  final double wbaPrice;
  final double cmp;
  final double plPercent;
  final double brokeragePercent;
  const SymbolWisePLReport({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.releasePL,
    required this.m2m,
    required this.brokerage,
    required this.netPL,
    required this.netQty,
    required this.netQtyPercent,
    required this.avgPrice,
    required this.wbaPrice,
    required this.cmp,
    required this.plPercent,
    required this.brokeragePercent,
  });
  @override
  List<Object?> get props => [
    id,
    exchange,
    symbol,
    releasePL,
    m2m,
    brokerage,
    netPL,
    netQty,
    netQtyPercent,
    avgPrice,
    wbaPrice,
    cmp,
    plPercent,
    brokeragePercent,
  ];
}
