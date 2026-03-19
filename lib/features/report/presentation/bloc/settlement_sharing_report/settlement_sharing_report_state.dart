import 'package:equatable/equatable.dart';
import '../../../domain/entities/settlement_sharing_report.dart';

abstract class SettlementSharingReportState extends Equatable {
  const SettlementSharingReportState();
  @override
  List<Object?> get props => [];
}

class SettlementSharingReportInitial extends SettlementSharingReportState {}

class SettlementSharingReportLoading extends SettlementSharingReportState {}

class SettlementSharingReportLoaded extends SettlementSharingReportState {
  final SettlementSharingReport report;
  final String selectedDateRange;
  final String? selectedUserId;
  final String? selectedUserName;
  const SettlementSharingReportLoaded({
    required this.report,
    required this.selectedDateRange,
    this.selectedUserId,
    this.selectedUserName,
  });
  @override
  List<Object?> get props => [
    report,
    selectedDateRange,
    selectedUserId,
    selectedUserName,
  ];
}

class SettlementSharingReportError extends SettlementSharingReportState {
  final String message;
  const SettlementSharingReportError({required this.message});
  @override
  List<Object?> get props => [message];
}