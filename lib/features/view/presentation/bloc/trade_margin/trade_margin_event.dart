import 'package:equatable/equatable.dart';
abstract class TradeMarginEvent extends Equatable {
  const TradeMarginEvent();
  @override
  List<Object?> get props => [];
}
class LoadTradeMargins extends TradeMarginEvent {
  const LoadTradeMargins();
}
class UpdateTradeMarginFilters extends TradeMarginEvent {
  final String? exchange;
  final String? search;
  const UpdateTradeMarginFilters({this.exchange, this.search});
  @override
  List<Object?> get props => [exchange, search];
}
class ViewTradeMargins extends TradeMarginEvent {
  const ViewTradeMargins();
}
class ResetTradeMarginFilters extends TradeMarginEvent {
  const ResetTradeMarginFilters();
}
