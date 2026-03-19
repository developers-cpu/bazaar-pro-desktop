import '../../../domain/entities/exchange_wise_pl/exchange_wise_pl_report.dart';

class ExchangeWisePLReportModel extends ExchangeWisePLReport {
  const ExchangeWisePLReportModel({
    required super.exchange,
    required super.m2m,
    required super.realisedPL,
    required super.brokerage,
    required super.totalPL,
    required super.ourPercent,
  });
  factory ExchangeWisePLReportModel.fromJson(Map<String, dynamic> json) {
    return ExchangeWisePLReportModel(
      exchange: json['exchange'],
      m2m: (json['m2m'] as num).toDouble(),
      realisedPL: (json['realisedPL'] as num).toDouble(),
      brokerage: (json['brokerage'] as num).toDouble(),
      totalPL: (json['totalPL'] as num).toDouble(),
      ourPercent: (json['ourPercent'] as num?)?.toDouble() ?? 0.0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'exchange': exchange,
      'm2m': m2m,
      'realisedPL': realisedPL,
      'brokerage': brokerage,
      'totalPL': totalPL,
      'ourPercent': ourPercent,
    };
  }
}