import 'package:equatable/equatable.dart';

/// User Entity - represents a user in the system
class User extends Equatable {
  final String id;
  final String userName;
  final String parentUser;
  final String type; // Master or Client
  final String name;
  final double plPercent; // P/L %
  final double brkPercent; // BRK %
  final String leverage; // LVRJ - e.g., "1:1"
  final double credit;
  final double pl; // P/L value
  final double equity;
  final double totalMargin; // TOT. MARGIN %
  final double usedMargin; // USED MARGIN %
  final double freeMargin; // FREE MARGIN %
  final DateTime createdDate;
  final DateTime? lastLoginDateTime;
  final String? deviceType; // TY. OFF DEVICE
  final String? ipAddress;
  final String status; // Active or In-Active

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

  /// Check if user is a Master
  bool get isMaster => type.toLowerCase() == 'master';

  /// Check if user is a Client
  bool get isClient => type.toLowerCase() == 'client';

  /// Check if user is active
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
