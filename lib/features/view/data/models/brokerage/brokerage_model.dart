import 'package:equatable/equatable.dart';
class BrokerageModel extends Equatable {
  final String exchange;
  final String symbol;
  final double brokeragePercentage;
  final double brokerageAmount;
  const BrokerageModel({
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
