import '../../domain/entities/profit_and_loss_report.dart';
class ProfitAndLossReportModel extends ProfitAndLossReport {
  const ProfitAndLossReportModel({
    required String id,
    required String userName,
    required double percentage,
    required double releasePL,
    required double brokerage,
    required double m2m,
    required double netPL,
    required double ourBrokerage,
    required double ourPercentage,
  }) : super(
         id: id,
         userName: userName,
         percentage: percentage,
         releasePL: releasePL,
         brokerage: brokerage,
         m2m: m2m,
         netPL: netPL,
         ourBrokerage: ourBrokerage,
         ourPercentage: ourPercentage,
       );
  factory ProfitAndLossReportModel.fromJson(Map<String, dynamic> json) {
    return ProfitAndLossReportModel(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      releasePL: (json['releasePL'] as num?)?.toDouble() ?? 0.0,
      brokerage: (json['brokerage'] as num?)?.toDouble() ?? 0.0,
      m2m: (json['m2m'] as num?)?.toDouble() ?? 0.0,
      netPL: (json['netPL'] as num?)?.toDouble() ?? 0.0,
      ourBrokerage: (json['ourBrokerage'] as num?)?.toDouble() ?? 0.0,
      ourPercentage: (json['ourPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
