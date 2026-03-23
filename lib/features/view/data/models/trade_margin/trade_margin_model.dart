import '../../../domain/entities/trade_margin/trade_margin.dart';

class TradeMarginModel extends TradeMargin {
  const TradeMarginModel({
    required super.exchange,
    required super.symbol,
    required super.expiryDate,
    required super.intMarginPct,
    required super.cfMarginPct,
    required super.intMarginAmt,
    required super.cfMarginAmt,
  });
  factory TradeMarginModel.fromJson(Map<String, dynamic> json) {
    return TradeMarginModel(
      exchange: json['exchange'] ?? '',
      symbol: json['symbol'] ?? '',
      expiryDate: DateTime.parse(json['expiryDate']),
      intMarginPct: (json['intMarginPct'] as num).toDouble(),
      cfMarginPct: (json['cfMarginPct'] as num).toDouble(),
      intMarginAmt: (json['intMarginAmt'] as num).toDouble(),
      cfMarginAmt: (json['cfMarginAmt'] as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'exchange': exchange,
      'symbol': symbol,
      'expiryDate': expiryDate.toIso8601String(),
      'intMarginPct': intMarginPct,
      'cfMarginPct': cfMarginPct,
      'intMarginAmt': intMarginAmt,
      'cfMarginAmt': cfMarginAmt,
    };
  }
}
