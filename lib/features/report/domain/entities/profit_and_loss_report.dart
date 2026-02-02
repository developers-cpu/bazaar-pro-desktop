import 'package:equatable/equatable.dart';

class ProfitAndLossReport extends Equatable {
  final String id;
  final String userName;
  final double percentage;
  final double releasePL;
  final double brokerage;
  final double m2m;
  final double netPL;
  final double ourBrokerage;
  final double ourPercentage;

  const ProfitAndLossReport({
    required this.id,
    required this.userName,
    required this.percentage,
    required this.releasePL,
    required this.brokerage,
    required this.m2m,
    required this.netPL,
    required this.ourBrokerage,
    required this.ourPercentage,
  });

  @override
  List<Object?> get props => [
    id,
    userName,
    percentage,
    releasePL,
    brokerage,
    m2m,
    netPL,
    ourBrokerage,
    ourPercentage,
  ];
}
