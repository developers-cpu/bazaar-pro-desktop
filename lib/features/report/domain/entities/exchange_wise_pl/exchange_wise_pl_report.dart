import 'package:equatable/equatable.dart';

class ExchangeWisePLReport extends Equatable {
  final String exchange;
  final double m2m;
  final double realisedPL;
  final double brokerage;
  final double totalPL;
  final double ourPercent;
  const ExchangeWisePLReport({
    required this.exchange,
    required this.m2m,
    required this.realisedPL,
    required this.brokerage,
    required this.totalPL,
    required this.ourPercent,
  });
  @override
  List<Object?> get props => [
    exchange,
    m2m,
    realisedPL,
    brokerage,
    totalPL,
    ourPercent,
  ];
}
