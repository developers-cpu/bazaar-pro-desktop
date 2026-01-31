import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String userName;
  final String parentUser;
  final String type;
  final String name;
  final double plPercent;
  final double brkPercent;
  final String leverage;
  final double credit;
  final double pl;
  final double equity;
  final double totalMargin;
  final double usedMargin;
  final double freeMargin;
  final DateTime createdDate;
  final DateTime? lastLoginDateTime;
  final String? deviceType;
  final String? ipAddress;
  final String status;

  const User({
    required this.id,
    required this.userName,
    required this.parentUser,
    required this.type,
    required this.name,
    required this.plPercent,
    required this.brkPercent,
    required this.leverage,
    required this.credit,
    required this.pl,
    required this.equity,
    required this.totalMargin,
    required this.usedMargin,
    required this.freeMargin,
    required this.createdDate,
    this.lastLoginDateTime,
    this.deviceType,
    this.ipAddress,
    required this.status,
  });

  bool get isMaster => type.toLowerCase() == 'master';
  bool get isClient => type.toLowerCase() == 'client';
  bool get isActive => status.toLowerCase() == 'active';

  @override
  List<Object?> get props => [
    id,
    userName,
    parentUser,
    type,
    name,
    plPercent,
    brkPercent,
    leverage,
    credit,
    pl,
    equity,
    totalMargin,
    usedMargin,
    freeMargin,
    createdDate,
    lastLoginDateTime,
    deviceType,
    ipAddress,
    status,
  ];
}
