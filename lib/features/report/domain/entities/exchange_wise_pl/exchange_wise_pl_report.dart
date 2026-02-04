import 'package:equatable/equatable.dart';
class ExchangeWisePLReport extends Equatable {
  final String exchange;
  final double m2m;
  final double realisedPL;
  final double brokerage;
  final double totalPL;
  const ExchangeWisePLReport({
    required this.exchange,
    required this.m2m,
    required this.realisedPL,
    required this.brokerage,
    required this.totalPL,
  });
  @override
  List<Object?> get props => [exchange, m2m, realisedPL, brokerage, totalPL];
}
