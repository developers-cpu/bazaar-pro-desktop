import 'package:equatable/equatable.dart';

class UserWiseProfitAndLossReport extends Equatable {
  final String id;
  final String userName;
  final String parentUser;
  final double mtm;
  final double releasedPL;
  final double brokerage;
  final double netPL;
  final double credit;
  final double equity;
  final double margin;
  final double usedMargin;
  final double freeMargin;
  final double standingVolume;
  final double marginLevelPercentage;
  final String createdBy;
  final DateTime createdDate;
  const UserWiseProfitAndLossReport({
    required this.id,
    required this.userName,
    required this.parentUser,
    required this.mtm,
    required this.releasedPL,
    required this.brokerage,
    required this.netPL,
    required this.credit,
    required this.equity,
    required this.margin,
    required this.usedMargin,
    required this.freeMargin,
    required this.standingVolume,
    required this.marginLevelPercentage,
    required this.createdBy,
    required this.createdDate,
  });
  @override
  List<Object?> get props => [
    id,
    userName,
    parentUser,
    mtm,
    releasedPL,
    brokerage,
    netPL,
    credit,
    equity,
    margin,
    usedMargin,
    freeMargin,
    standingVolume,
    marginLevelPercentage,
    createdBy,
    createdDate,
  ];
}
