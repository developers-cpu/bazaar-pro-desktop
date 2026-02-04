import 'package:equatable/equatable.dart';
import '../../../domain/entities/profit_and_loss_report.dart';
abstract class ProfitAndLossReportState extends Equatable {
  const ProfitAndLossReportState();
  @override
  List<Object?> get props => [];
}
class ProfitAndLossReportInitial extends ProfitAndLossReportState {}
class ProfitAndLossReportLoading extends ProfitAndLossReportState {}
class ProfitAndLossReportLoaded extends ProfitAndLossReportState {
  final List<ProfitAndLossReport> reports;
  final List<String> userNames;
  final String? selectedUser;
  const ProfitAndLossReportLoaded({
    required this.reports,
    this.userNames = const [],
    this.selectedUser,
  });
  ProfitAndLossReportLoaded copyWith({
    List<ProfitAndLossReport>? reports,
    List<String>? userNames,
    String? selectedUser,
  }) {
    return ProfitAndLossReportLoaded(
      reports: reports ?? this.reports,
      userNames: userNames ?? this.userNames,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }
  @override
  List<Object?> get props => [reports, userNames, selectedUser];
}
class ProfitAndLossReportError extends ProfitAndLossReportState {
  final String message;
  const ProfitAndLossReportError({required this.message});
  @override
  List<Object> get props => [message];
}
