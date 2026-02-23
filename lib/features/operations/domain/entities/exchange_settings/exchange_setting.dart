import 'package:equatable/equatable.dart';

class ExchangeSetting extends Equatable {
  final String id;
  final String exchange;
  final bool betweenHighLowLimitPlace;
  final bool autoTickSize;
  final String tickSize;
  final List<String> orderType;
  final bool oddLot;
  final String marketPriceType;
  final String sequence;
  final String updatedOn;
  final String updatedBy;

  const ExchangeSetting({
    required this.id,
    required this.exchange,
    required this.betweenHighLowLimitPlace,
    required this.autoTickSize,
    required this.tickSize,
    required this.orderType,
    required this.oddLot,
    required this.marketPriceType,
    required this.sequence,
    required this.updatedOn,
    required this.updatedBy,
  });

  @override
  List<Object?> get props => [
    id,
    exchange,
    betweenHighLowLimitPlace,
    autoTickSize,
    tickSize,
    orderType,
    oddLot,
    marketPriceType,
    sequence,
    updatedOn,
    updatedBy,
  ];
}

class DefaultSymbol extends Equatable {
  final String id;
  final String symbol;
  final String exchange;
  final String updatedOn;
  final String updatedBy;
  final bool showInWatchlist;

  const DefaultSymbol({
    required this.id,
    required this.symbol,
    required this.exchange,
    required this.updatedOn,
    required this.updatedBy,
    required this.showInWatchlist,
  });

  @override
  List<Object?> get props => [
    id,
    symbol,
    exchange,
    updatedOn,
    updatedBy,
    showInWatchlist,
  ];
}
