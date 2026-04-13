import '../../domain/entities/spraed_report_entity.dart';

class SpraedReportModel extends SpraedReportEntity {
  const SpraedReportModel({
    required super.id,
    required super.exchange,
    required super.symbol,
    required super.spreadPercentage,
  });

  factory SpraedReportModel.fromJson(Map<String, dynamic> json) {
    return SpraedReportModel(
      id: json['id'] ?? '',
      exchange: json['exchange'] ?? '',
      symbol: json['symbol'] ?? '',
      spreadPercentage: json['spreadPercentage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'symbol': symbol,
      'spreadPercentage': spreadPercentage,
    };
  }
}
