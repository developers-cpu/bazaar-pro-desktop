import 'package:equatable/equatable.dart';
abstract class TradeMarginEvent extends Equatable {
  const TradeMarginEvent();
  @override
  List<Object?> get props => [];
}
class LoadTradeMargins extends TradeMarginEvent {
  const LoadTradeMargins();
}
class FilterTradeMargins extends TradeMarginEvent {
  final String? exchange;
  final String? search;
  const FilterTradeMargins({this.exchange, this.search});
  @override
  List<Object?> get props => [exchange, search];
}
class ResetTradeMarginFilters extends TradeMarginEvent {
  const ResetTradeMarginFilters();
}
