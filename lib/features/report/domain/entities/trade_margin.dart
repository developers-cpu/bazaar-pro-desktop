import 'package:equatable/equatable.dart';

class TradeMargin extends Equatable {
  final String exchange;
  final String symbol;
  final DateTime expiryDate;
  final double marginPercentage;
  final double marginAmount;

  const TradeMargin({
    required this.exchange,
    required this.symbol,
    required this.expiryDate,
    required this.marginPercentage,
    required this.marginAmount,
  });

  @override
  List<Object?> get props => [
    exchange,
    symbol,
    expiryDate,
    marginPercentage,
    marginAmount,
  ];
}
