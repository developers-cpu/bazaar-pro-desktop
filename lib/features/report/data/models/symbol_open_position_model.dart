import '../../domain/entities/symbol_open_position.dart';
class SymbolOpenPositionModel extends SymbolOpenPosition {
  const SymbolOpenPositionModel({
    required String name,
    required String type,
    required String exchange,
    required String symbol,
    required double buyQty,
    required double sellQty,
    required double netQty,
    required double netAvgPrice,
    required double cmp,
    required double m2m,
    required double ourPercent,
    required String user,
    required int days,
  }) : super(
         name: name,
         type: type,
         exchange: exchange,
         symbol: symbol,
         buyQty: buyQty,
         sellQty: sellQty,
         netQty: netQty,
         netAvgPrice: netAvgPrice,
         cmp: cmp,
         m2m: m2m,
         ourPercent: ourPercent,
         user: user,
         days: days,
       );
  factory SymbolOpenPositionModel.fromJson(Map<String, dynamic> json) {
    return SymbolOpenPositionModel(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      exchange: json['exchange'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      buyQty: (json['buyQty'] as num?)?.toDouble() ?? 0.0,
      sellQty: (json['sellQty'] as num?)?.toDouble() ?? 0.0,
      netQty: (json['netQty'] as num?)?.toDouble() ?? 0.0,
      netAvgPrice: (json['netAvgPrice'] as num?)?.toDouble() ?? 0.0,
      cmp: (json['cmp'] as num?)?.toDouble() ?? 0.0,
      m2m: (json['m2m'] as num?)?.toDouble() ?? 0.0,
      ourPercent: (json['ourPercent'] as num?)?.toDouble() ?? 0.0,
      user: json['user'] as String? ?? '',
      days: (json['days'] as num?)?.toInt() ?? 0,
    );
  }
}
