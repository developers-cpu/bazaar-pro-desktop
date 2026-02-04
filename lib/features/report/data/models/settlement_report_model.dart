import '../../domain/entities/settlement_report.dart';

class SettlementReportModel extends SettlementReport {
  const SettlementReportModel({
    required List<SettlementEntryModel> profitList,
    required List<SettlementEntryModel> lossList,
    required SettlementTotalModel profitTotal,
    required SettlementTotalModel lossTotal,
  }) : super(
         profitList: profitList,
         lossList: lossList,
         profitTotal: profitTotal,
         lossTotal: lossTotal,
       );

  factory SettlementReportModel.fromJson(Map<String, dynamic> json) {
    return SettlementReportModel(
      profitList: (json['profitList'] as List)
          .map((e) => SettlementEntryModel.fromJson(e))
          .toList(),
      lossList: (json['lossList'] as List)
          .map((e) => SettlementEntryModel.fromJson(e))
          .toList(),
      profitTotal: SettlementTotalModel.fromJson(json['profitTotal']),
      lossTotal: SettlementTotalModel.fromJson(json['lossTotal']),
    );
  }
}

class SettlementEntryModel extends SettlementEntry {
  const SettlementEntryModel({
    required String userId,
    required String username,
    required String userType,
    required double pnl,
    required double brokerage,
    required double total,
  }) : super(
         userId: userId,
         username: username,
         userType: userType,
         pnl: pnl,
         brokerage: brokerage,
         total: total,
       );

  factory SettlementEntryModel.fromJson(Map<String, dynamic> json) {
    return SettlementEntryModel(
      userId: json['userId'],
      username: json['username'],
      userType: json['userType'],
      pnl: (json['pnl'] as num).toDouble(),
      brokerage: (json['brokerage'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

class SettlementTotalModel extends SettlementTotal {
  const SettlementTotalModel({
    required double totalPnl,
    required double totalBrokerage,
    required double totalAmount,
  }) : super(
         totalPnl: totalPnl,
         totalBrokerage: totalBrokerage,
         totalAmount: totalAmount,
       );

  factory SettlementTotalModel.fromJson(Map<String, dynamic> json) {
    return SettlementTotalModel(
      totalPnl: (json['totalPnl'] as num).toDouble(),
      totalBrokerage: (json['totalBrokerage'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}
