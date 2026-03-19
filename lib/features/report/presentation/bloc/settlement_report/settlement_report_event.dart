import 'package:equatable/equatable.dart';

abstract class SettlementReportEvent extends Equatable {
  const SettlementReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettlementReport extends SettlementReportEvent {
  final String dateRange;
  final String? userId;
  const LoadSettlementReport({this.dateRange = 'This Week', this.userId});
  @override
  List<Object?> get props => [dateRange, userId];
}

class SelectUserForDetail extends SettlementReportEvent {
  final String userId;
  final String username;
  const SelectUserForDetail({required this.userId, required this.username});
  @override
  List<Object?> get props => [userId, username];
}

class ClearSelectedUser extends SettlementReportEvent {}