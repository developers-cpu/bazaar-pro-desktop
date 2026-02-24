import 'package:equatable/equatable.dart';
import '../../../domain/entities/settlement_report.dart';

abstract class SettlementReportState extends Equatable {
  const SettlementReportState();
  @override
  List<Object?> get props => [];
}

class SettlementReportInitial extends SettlementReportState {}

class SettlementReportLoading extends SettlementReportState {}

class SettlementReportLoaded extends SettlementReportState {
  final SettlementReport report;
  final String selectedDateRange;
  final String? selectedUserId;
  final String? selectedUserName;
  const SettlementReportLoaded({
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

class SettlementReportError extends SettlementReportState {
  final String message;
  const SettlementReportError({required this.message});
  @override
  List<Object?> get props => [message];
}
