import '../../domain/entities/user_wise_profit_and_loss_report.dart';

class UserWiseProfitAndLossReportModel extends UserWiseProfitAndLossReport {
  const UserWiseProfitAndLossReportModel({
    required super.id,
    required super.userName,
    required super.parentUser,
    required super.mtm,
    required super.releasedPL,
    required super.brokerage,
    required super.netPL,
    required super.credit,
    required super.equity,
    required super.margin,
    required super.usedMargin,
    required super.freeMargin,
    required super.standingVolume,
    required super.marginLevelPercentage,
    required super.createdBy,
    required super.createdDate,
  });
  factory UserWiseProfitAndLossReportModel.fromJson(Map<String, dynamic> json) {
    return UserWiseProfitAndLossReportModel(
      id: json['id'] as String? ?? '',
      userName: json['userName'] as String? ?? 'Deleted User',
      parentUser: json['parentUser'] as String? ?? '',
      mtm: (json['mtm'] as num?)?.toDouble() ?? 0.0,
      releasedPL: (json['releasedPL'] as num?)?.toDouble() ?? 0.0,
      brokerage: (json['brokerage'] as num?)?.toDouble() ?? 0.0,
      netPL: (json['netPL'] as num?)?.toDouble() ?? 0.0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
      equity: (json['equity'] as num?)?.toDouble() ?? 0.0,
      margin: (json['margin'] as num?)?.toDouble() ?? 0.0,
      usedMargin: (json['usedMargin'] as num?)?.toDouble() ?? 0.0,
      freeMargin: (json['freeMargin'] as num?)?.toDouble() ?? 0.0,
      standingVolume: (json['standingVolume'] as num?)?.toDouble() ?? 0.0,
      marginLevelPercentage:
          (json['marginLevelPercentage'] as num?)?.toDouble() ?? 0.0,
      createdBy: json['createdBy'] as String? ?? '',
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : DateTime.now(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'parentUser': parentUser,
      'mtm': mtm,
      'releasedPL': releasedPL,
      'brokerage': brokerage,
      'netPL': netPL,
      'credit': credit,
      'equity': equity,
      'margin': margin,
      'usedMargin': usedMargin,
      'freeMargin': freeMargin,
      'standingVolume': standingVolume,
      'marginLevelPercentage': marginLevelPercentage,
      'createdBy': createdBy,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}