import 'package:equatable/equatable.dart';

class TradeMargin extends Equatable {
  final String exchange;
  final String symbol;
  final DateTime expiryDate;
  final double intMarginPct;
  final double cfMarginPct;
  final double intMarginAmt;
  final double cfMarginAmt;
  const TradeMargin({
    required this.exchange,
    required this.symbol,
    required this.expiryDate,
    required this.intMarginPct,
    required this.cfMarginPct,
    required this.intMarginAmt,
    required this.cfMarginAmt,
  });
  @override
  List<Object?> get props => [
    exchange,
    symbol,
    expiryDate,
    intMarginPct,
    cfMarginPct,
    intMarginAmt,
    cfMarginAmt,
  ];
}
