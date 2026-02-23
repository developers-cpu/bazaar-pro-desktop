import 'package:equatable/equatable.dart';
abstract class RejectionLogEvent extends Equatable {
  const RejectionLogEvent();
  @override
  List<Object?> get props => [];
}
class LoadRejectionLogsEvent extends RejectionLogEvent {
  const LoadRejectionLogsEvent();
}
class ApplyRejectionLogFiltersEvent extends RejectionLogEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? client;
  final String? exchange;
  final String? symbol;
  const ApplyRejectionLogFiltersEvent({
    this.startDate,
    this.endDate,
    this.client,
    this.exchange,
    this.symbol,
  });
  @override
  List<Object?> get props => [startDate, endDate, client, exchange, symbol];
}
class ResetRejectionLogFiltersEvent extends RejectionLogEvent {
  const ResetRejectionLogFiltersEvent();
}
class SortRejectionLogsByColumnEvent extends RejectionLogEvent {
  final String columnId;
  final bool ascending;
  const SortRejectionLogsByColumnEvent({
    required this.columnId,
    required this.ascending,
  });
  @override
  List<Object?> get props => [columnId, ascending];
}
class ExportRejectionLogsToPdfEvent extends RejectionLogEvent {
  const ExportRejectionLogsToPdfEvent();
}
class ExportRejectionLogsToExcelEvent extends RejectionLogEvent {
  const ExportRejectionLogsToExcelEvent();
}
