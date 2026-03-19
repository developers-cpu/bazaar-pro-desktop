import 'package:equatable/equatable.dart';

class SettlementSharingReport extends Equatable {
  final List<SettlementSharingEntry> profitList;
  final List<SettlementSharingEntry> lossList;
  final SettlementSharingTotal profitTotal;
  final SettlementSharingTotal lossTotal;
  const SettlementSharingReport({
    required this.profitList,
    required this.lossList,
    required this.profitTotal,
    required this.lossTotal,
  });
  @override
  List<Object?> get props => [profitList, lossList, profitTotal, lossTotal];
}

class SettlementSharingEntry extends Equatable {
  final String userId;
  final String username;
  final String userType;
  final double pnl;
  final double percentWise;
  final double total;
  const SettlementSharingEntry({
    required this.userId,
    required this.username,
    required this.userType,
    required this.pnl,
    required this.percentWise,
    required this.total,
  });
  @override
  List<Object?> get props => [
    userId,
    username,
    userType,
    pnl,
    percentWise,
    total,
  ];
}

class SettlementSharingTotal extends Equatable {
  final double totalPnl;
  final double totalPercentWise;
  final double totalAmount;
  const SettlementSharingTotal({
    required this.totalPnl,
    required this.totalPercentWise,
    required this.totalAmount,
  });
  @override
  List<Object?> get props => [totalPnl, totalPercentWise, totalAmount];
}