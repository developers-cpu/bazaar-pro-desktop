import 'package:equatable/equatable.dart';
abstract class ProfitAndLossReportEvent extends Equatable {
  const ProfitAndLossReportEvent();
  @override
  List<Object?> get props => [];
}
class LoadProfitAndLossReport extends ProfitAndLossReportEvent {
  const LoadProfitAndLossReport();
}
class FilterProfitAndLossReport extends ProfitAndLossReportEvent {
  final String? userId;
  const FilterProfitAndLossReport({this.userId});
  @override
  List<Object?> get props => [userId];
}
class ResetProfitAndLossReportFilters extends ProfitAndLossReportEvent {
  const ResetProfitAndLossReportFilters();
}
