import '../../domain/entities/settlement_sharing_report.dart';

class SettlementSharingReportModel extends SettlementSharingReport {
  const SettlementSharingReportModel({
    required List<SettlementSharingEntryModel> profitList,
    required List<SettlementSharingEntryModel> lossList,
    required SettlementSharingTotalModel profitTotal,
    required SettlementSharingTotalModel lossTotal,
  }) : super(
         profitList: profitList,
         lossList: lossList,
         profitTotal: profitTotal,
         lossTotal: lossTotal,
       );
  factory SettlementSharingReportModel.fromJson(Map<String, dynamic> json) {
    return SettlementSharingReportModel(
      profitList: (json['profitList'] as List)
          .map((e) => SettlementSharingEntryModel.fromJson(e))
          .toList(),
      lossList: (json['lossList'] as List)
          .map((e) => SettlementSharingEntryModel.fromJson(e))
          .toList(),
      profitTotal: SettlementSharingTotalModel.fromJson(json['profitTotal']),
      lossTotal: SettlementSharingTotalModel.fromJson(json['lossTotal']),
    );
  }
}

class SettlementSharingEntryModel extends SettlementSharingEntry {
  const SettlementSharingEntryModel({
    required String userId,
    required String username,
    required String userType,
    required double pnl,
    required double percentWise,
    required double total,
  }) : super(
         userId: userId,
         username: username,
         userType: userType,
         pnl: pnl,
         percentWise: percentWise,
         total: total,
       );
  factory SettlementSharingEntryModel.fromJson(Map<String, dynamic> json) {
    return SettlementSharingEntryModel(
      userId: json['userId'],
      username: json['username'],
      userType: json['userType'],
      pnl: (json['pnl'] as num).toDouble(),
      percentWise: (json['percentWise'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

class SettlementSharingTotalModel extends SettlementSharingTotal {
  const SettlementSharingTotalModel({
    required double totalPnl,
    required double totalPercentWise,
    required double totalAmount,
  }) : super(
         totalPnl: totalPnl,
         totalPercentWise: totalPercentWise,
         totalAmount: totalAmount,
       );
  factory SettlementSharingTotalModel.fromJson(Map<String, dynamic> json) {
    return SettlementSharingTotalModel(
      totalPnl: (json['totalPnl'] as num).toDouble(),
      totalPercentWise: (json['totalPercentWise'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}