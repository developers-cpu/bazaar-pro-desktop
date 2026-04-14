import 'package:equatable/equatable.dart';

class ExchangeMarketTiming extends Equatable {
  final String id;
  final String exchange;
  final String date;
  final bool isOn;
  final String timing;

  const ExchangeMarketTiming({
    required this.id,
    required this.exchange,
    required this.date,
    required this.isOn,
    required this.timing,
  });

  @override
  List<Object?> get props => [id, exchange, date, isOn, timing];
}
