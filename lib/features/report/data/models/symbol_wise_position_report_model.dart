import '../../domain/entities/symbol_wise_position_report.dart';

class SymbolWisePositionReportModel extends SymbolWisePositionReport {
  const SymbolWisePositionReportModel({
    required super.id,
    required super.exchange,
    required super.symbol,
    required super.netQty,
    required super.netQtyPercent,
    required super.avgPrice,
    required super.brokerage,
    required super.wbaPrice,
    required super.cmp,
    required super.pl,
    required super.plPercent,
    required super.brokeragePercent,
  });

  factory SymbolWisePositionReportModel.fromJson(Map<String, dynamic> json) {
    return SymbolWisePositionReportModel(
      id: json['id'] ?? '',
      exchange: json['exchange'] ?? '',
      symbol: json['symbol'] ?? '',
      netQty: (json['netQty'] as num?)?.toDouble() ?? 0.0,
      netQtyPercent: (json['netQtyPercent'] as num?)?.toDouble() ?? 0.0,
      avgPrice: (json['avgPrice'] as num?)?.toDouble() ?? 0.0,
      brokerage: (json['brokerage'] as num?)?.toDouble() ?? 0.0,
      wbaPrice: (json['wbaPrice'] as num?)?.toDouble() ?? 0.0,
      cmp: (json['cmp'] as num?)?.toDouble() ?? 0.0,
      pl: (json['pl'] as num?)?.toDouble() ?? 0.0,
      plPercent: (json['plPercent'] as num?)?.toDouble() ?? 0.0,
      brokeragePercent: (json['brokeragePercent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
