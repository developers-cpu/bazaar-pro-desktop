import 'package:equatable/equatable.dart';

class SpraedReportEntity extends Equatable {
  final String id;
  final String exchange;
  final String symbol;
  final String spreadPercentage;

  const SpraedReportEntity({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.spreadPercentage,
  });

  @override
  List<Object?> get props => [id, exchange, symbol, spreadPercentage];
}
