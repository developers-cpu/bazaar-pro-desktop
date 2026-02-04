import 'package:equatable/equatable.dart';
abstract class ScriptMasterEvent extends Equatable {
  const ScriptMasterEvent();
  @override
  List<Object?> get props => [];
}
class LoadScriptMastersEvent extends ScriptMasterEvent {
  const LoadScriptMastersEvent();
}
class ApplyFiltersEvent extends ScriptMasterEvent {
  final String? exchange;
  final String? symbol;
  const ApplyFiltersEvent({
    this.exchange,
    this.symbol,
  });
  @override
  List<Object?> get props => [
    exchange,
    symbol,
  ];
}
class ResetFiltersEvent extends ScriptMasterEvent {
  const ResetFiltersEvent();
}
class SelectScriptEvent extends ScriptMasterEvent {
  final String scriptId;
  const SelectScriptEvent(this.scriptId);
  @override
  List<Object?> get props => [scriptId];
}
class SortScriptsByColumnEvent extends ScriptMasterEvent {
  final String columnId;
  final bool ascending;
  const SortScriptsByColumnEvent({
    required this.columnId,
    required this.ascending,
  });
  @override
  List<Object?> get props => [columnId, ascending];
}
class ExportScriptMastersToPdfEvent extends ScriptMasterEvent {
  const ExportScriptMastersToPdfEvent();
}
class ExportScriptMastersToExcelEvent extends ScriptMasterEvent {
  const ExportScriptMastersToExcelEvent();
}
