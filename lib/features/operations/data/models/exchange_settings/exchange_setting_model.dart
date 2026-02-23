import '../../../domain/entities/exchange_settings/exchange_setting.dart';

class ExchangeSettingModel extends ExchangeSetting {
  const ExchangeSettingModel({
    required super.id,
    required super.exchange,
    required super.betweenHighLowLimitPlace,
    required super.autoTickSize,
    required super.tickSize,
    required super.orderType,
    required super.oddLot,
    required super.marketPriceType,
    required super.sequence,
    required super.updatedOn,
    required super.updatedBy,
  });

  factory ExchangeSettingModel.fromJson(Map<String, dynamic> json) {
    return ExchangeSettingModel(
      id: json['id'] ?? '',
      exchange: json['exchange'] ?? '',
      betweenHighLowLimitPlace: json['between_high_low_limit_place'] ?? false,
      autoTickSize: json['auto_tick_size'] ?? false,
      tickSize: json['tick_size'] ?? '0',
      orderType: List<String>.from(json['order_type'] ?? []),
      oddLot: json['odd_lot'] ?? false,
      marketPriceType: json['market_price_type'] ?? 'Full',
      sequence: json['sequence'] ?? '01',
      updatedOn: json['updated_on'] ?? '',
      updatedBy: json['updated_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'between_high_low_limit_place': betweenHighLowLimitPlace,
      'auto_tick_size': autoTickSize,
      'tick_size': tickSize,
      'order_type': orderType,
      'odd_lot': oddLot,
      'market_price_type': marketPriceType,
      'sequence': sequence,
      'updated_on': updatedOn,
      'updated_by': updatedBy,
    };
  }
}

class DefaultSymbolModel extends DefaultSymbol {
  const DefaultSymbolModel({
    required super.id,
    required super.symbol,
    required super.exchange,
    required super.updatedOn,
    required super.updatedBy,
    required super.showInWatchlist,
  });

  factory DefaultSymbolModel.fromJson(Map<String, dynamic> json) {
    return DefaultSymbolModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      exchange: json['exchange'] ?? '',
      updatedOn: json['updated_on'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      showInWatchlist: json['show_in_watchlist'] ?? false,
    );
  }
}
