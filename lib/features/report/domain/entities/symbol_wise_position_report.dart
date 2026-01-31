import 'package:equatable/equatable.dart';

class SymbolWisePositionReport extends Equatable {
  final String id;
  final String exchange;
  final String symbol;
  final double netQty;
  final double netQtyPercent;
  final double avgPrice;
  final double brokerage;
  final double wbaPrice;
  final double cmp;
  final double pl;
  final double plPercent;
  final double brokeragePercent;

  const SymbolWisePositionReport({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.netQty,
    required this.netQtyPercent,
    required this.avgPrice,
    required this.brokerage,
    required this.wbaPrice,
    required this.cmp,
    required this.pl,
    required this.plPercent,
    required this.brokeragePercent,
  });

  @override
  List<Object?> get props => [
    id,
    exchange,
    symbol,
    netQty,
    netQtyPercent,
    avgPrice,
    brokerage,
    wbaPrice,
    cmp,
    pl,
    plPercent,
    brokeragePercent,
  ];
}
