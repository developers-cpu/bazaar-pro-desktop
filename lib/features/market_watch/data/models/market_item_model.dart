import '../../domain/entities/market_item.dart';

class MarketItemModel extends MarketItem {
  const MarketItemModel({
    required super.id,
    required super.exchange,
    required super.symbol,
    required super.buyQty,
    required super.buyPrice,
    required super.sellPrice,
    required super.sellQty,
    required super.netChange,
    required super.high,
    required super.low,
    required super.open,
    required super.close,
    required super.ltp,
    required super.netChangePercent,
    super.expiry,
    required super.lut,
  });

  factory MarketItemModel.fromJson(Map<String, dynamic> json) {
    return MarketItemModel(
      id: json['id'] as String,
      exchange: json['exchange'] as String,
      symbol: json['symbol'] as String,
      buyQty: json['buyQty'] as int,
      buyPrice: (json['buyPrice'] as num).toDouble(),
      sellPrice: (json['sellPrice'] as num).toDouble(),
      sellQty: json['sellQty'] as int,
      netChange: (json['netChange'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      open: (json['open'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      ltp: (json['ltp'] as num).toDouble(),
      netChangePercent: (json['netChangePercent'] as num).toDouble(),
      expiry: json['expiry'] != null 
          ? DateTime.parse(json['expiry'] as String) 
          : null,
      lut: DateTime.parse(json['lut'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'symbol': symbol,
      'buyQty': buyQty,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'sellQty': sellQty,
      'netChange': netChange,
      'high': high,
      'low': low,
      'open': open,
      'close': close,
      'ltp': ltp,
      'netChangePercent': netChangePercent,
      'expiry': expiry?.toIso8601String(),
      'lut': lut.toIso8601String(),
    };
  }

  factory MarketItemModel.fromEntity(MarketItem entity) {
    return MarketItemModel(
      id: entity.id,
      exchange: entity.exchange,
      symbol: entity.symbol,
      buyQty: entity.buyQty,
      buyPrice: entity.buyPrice,
      sellPrice: entity.sellPrice,
      sellQty: entity.sellQty,
      netChange: entity.netChange,
      high: entity.high,
      low: entity.low,
      open: entity.open,
      close: entity.close,
      ltp: entity.ltp,
      netChangePercent: entity.netChangePercent,
      expiry: entity.expiry,
      lut: entity.lut,
    );
  }

  MarketItem toEntity() {
    return MarketItem(
      id: id,
      exchange: exchange,
      symbol: symbol,
      buyQty: buyQty,
      buyPrice: buyPrice,
      sellPrice: sellPrice,
      sellQty: sellQty,
      netChange: netChange,
      high: high,
      low: low,
      open: open,
      close: close,
      ltp: ltp,
      netChangePercent: netChangePercent,
      expiry: expiry,
      lut: lut,
    );
  }
}
