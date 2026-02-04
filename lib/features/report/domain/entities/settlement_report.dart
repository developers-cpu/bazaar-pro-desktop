import 'package:equatable/equatable.dart';

class SettlementReport extends Equatable {
  final List<SettlementEntry> profitList;
  final List<SettlementEntry> lossList;
  final SettlementTotal profitTotal;
  final SettlementTotal lossTotal;

  const SettlementReport({
    required this.profitList,
    required this.lossList,
    required this.profitTotal,
    required this.lossTotal,
  });

  @override
  List<Object?> get props => [profitList, lossList, profitTotal, lossTotal];
}

class SettlementEntry extends Equatable {
  final String userId;
  final String username;
  final String userType; 
  final double pnl;
  final double brokerage;
  final double total;

  const SettlementEntry({
    required this.userId,
    required this.username,
    required this.userType,
    required this.pnl,
    required this.brokerage,
    required this.total,
  });

  @override
  List<Object?> get props => [
    userId,
    username,
    userType,
    pnl,
    brokerage,
    total,
  ];
}

class SettlementTotal extends Equatable {
  final double totalPnl;
  final double totalBrokerage;
  final double totalAmount;

  const SettlementTotal({
    required this.totalPnl,
    required this.totalBrokerage,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [totalPnl, totalBrokerage, totalAmount];
}
