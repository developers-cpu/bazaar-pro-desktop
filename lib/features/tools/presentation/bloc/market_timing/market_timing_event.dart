import 'package:equatable/equatable.dart';
abstract class MarketTimingEvent extends Equatable {
  const MarketTimingEvent();
  @override
  List<Object> get props => [];
}
class GetMarketTimingEvent extends MarketTimingEvent {
  final String exchange;
  final DateTime date;
  const GetMarketTimingEvent({required this.exchange, required this.date});
  @override
  List<Object> get props => [exchange, date];
}
