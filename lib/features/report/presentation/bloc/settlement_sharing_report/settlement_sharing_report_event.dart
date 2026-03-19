import 'package:equatable/equatable.dart';

abstract class SettlementSharingReportEvent extends Equatable {
  const SettlementSharingReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettlementSharingReport extends SettlementSharingReportEvent {
  final String dateRange;
  final String? userId;
  const LoadSettlementSharingReport({
    this.dateRange = 'This Week',
    this.userId,
  });
  @override
  List<Object?> get props => [dateRange, userId];
}

class SelectUserForDetail extends SettlementSharingReportEvent {
  final String userId;
  final String username;
  const SelectUserForDetail({required this.userId, required this.username});
  @override
  List<Object?> get props => [userId, username];
}

class ClearSelectedUser extends SettlementSharingReportEvent {}