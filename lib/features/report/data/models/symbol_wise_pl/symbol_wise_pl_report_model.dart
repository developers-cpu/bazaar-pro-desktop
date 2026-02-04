import '../../../domain/entities/symbol_wise_pl/symbol_wise_pl_report.dart';

class SymbolWisePLReportModel extends SymbolWisePLReport {
  const SymbolWisePLReportModel({
    required String id,
    required String exchange,
    required String symbol,
    required double releasePL,
    required double m2m,
    required double brokerage,
    required double netPL,
    required double netQty,
    required double netQtyPercent,
    required double avgPrice,
    required double wbaPrice,
    required double cmp,
    required double plPercent,
    required double brokeragePercent,
  }) : super(
         id: id,
         exchange: exchange,
         symbol: symbol,
         releasePL: releasePL,
         m2m: m2m,
         brokerage: brokerage,
         netPL: netPL,
         netQty: netQty,
         netQtyPercent: netQtyPercent,
         avgPrice: avgPrice,
         wbaPrice: wbaPrice,
         cmp: cmp,
         plPercent: plPercent,
         brokeragePercent: brokeragePercent,
       );

  factory SymbolWisePLReportModel.fromJson(Map<String, dynamic> json) {
    return SymbolWisePLReportModel(
      id: json['id'] as String? ?? '',
      exchange: json['exchange'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      releasePL: (json['releasePL'] as num?)?.toDouble() ?? 0.0,
      m2m: (json['m2m'] as num?)?.toDouble() ?? 0.0,
      brokerage: (json['brokerage'] as num?)?.toDouble() ?? 0.0,
      netPL: (json['netPL'] as num?)?.toDouble() ?? 0.0,
      netQty: (json['netQty'] as num?)?.toDouble() ?? 0.0,
      netQtyPercent: (json['netQtyPercent'] as num?)?.toDouble() ?? 0.0,
      avgPrice: (json['avgPrice'] as num?)?.toDouble() ?? 0.0,
      wbaPrice: (json['wbaPrice'] as num?)?.toDouble() ?? 0.0,
      cmp: (json['cmp'] as num?)?.toDouble() ?? 0.0,
      plPercent: (json['plPercent'] as num?)?.toDouble() ?? 0.0,
      brokeragePercent: (json['brokeragePercent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
