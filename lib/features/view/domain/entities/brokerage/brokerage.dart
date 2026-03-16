import 'package:equatable/equatable.dart';

class Brokerage extends Equatable {
  final String exchange;
  final String symbol;
  final double brokeragePercentage;
  final double brokerageAmount;
  const Brokerage({
    required this.exchange,
    required this.symbol,
    required this.brokeragePercentage,
    required this.brokerageAmount,
  });
  @override
  List<Object?> get props => [
    exchange,
    symbol,
    brokeragePercentage,
    brokerageAmount,
  ];
}
