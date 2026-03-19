import 'package:equatable/equatable.dart';

abstract class MarketDepthEvent extends Equatable {
  const MarketDepthEvent();
  @override
  List<Object?> get props => [];
}

class OpenMarketDepthEvent extends MarketDepthEvent {
  final String? exchange;
  final String? symbol;
  const OpenMarketDepthEvent({this.exchange, this.symbol});
  @override
  List<Object?> get props => [exchange, symbol];
}

class CloseMarketDepthEvent extends MarketDepthEvent {
  const CloseMarketDepthEvent();
}

class UpdateExchangeEvent extends MarketDepthEvent {
  final String exchange;
  const UpdateExchangeEvent(this.exchange);
  @override
  List<Object?> get props => [exchange];
}

class UpdateSymbolEvent extends MarketDepthEvent {
  final String symbol;
  const UpdateSymbolEvent(this.symbol);
  @override
  List<Object?> get props => [symbol];
}

class RefreshMarketDepthEvent extends MarketDepthEvent {
  const RefreshMarketDepthEvent();
}