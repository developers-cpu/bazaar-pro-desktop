import '../../../domain/entities/trade_margin/trade_margin.dart';

class TradeMarginModel extends TradeMargin {
  const TradeMarginModel({
    required super.exchange,
    required super.symbol,
    required super.expiryDate,
    required super.marginPercentage,
    required super.marginAmount,
  });
  factory TradeMarginModel.fromJson(Map<String, dynamic> json) {
    return TradeMarginModel(
      exchange: json['exchange'] ?? '',
      symbol: json['symbol'] ?? '',
      expiryDate: DateTime.parse(json['expiryDate']),
      marginPercentage: (json['marginPercentage'] as num).toDouble(),
      marginAmount: (json['marginAmount'] as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'exchange': exchange,
      'symbol': symbol,
      'expiryDate': expiryDate.toIso8601String(),
      'marginPercentage': marginPercentage,
      'marginAmount': marginAmount,
    };
  }
}
