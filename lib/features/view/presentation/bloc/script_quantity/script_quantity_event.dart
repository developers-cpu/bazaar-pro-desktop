import 'package:equatable/equatable.dart';
abstract class ScriptQuantityEvent extends Equatable {
  const ScriptQuantityEvent();
  @override
  List<Object?> get props => [];
}
class LoadFiltersEvent extends ScriptQuantityEvent {
  const LoadFiltersEvent();
}
class RestoreFiltersEvent extends ScriptQuantityEvent {
  final String exchange;
  final String group;
  const RestoreFiltersEvent(this.exchange, this.group);
  @override
  List<Object?> get props => [exchange, group];
}
class UpdateScriptQuantityFilterEvent extends ScriptQuantityEvent {
  final String exchange;
  const UpdateScriptQuantityFilterEvent(this.exchange);
  @override
  List<Object?> get props => [exchange];
}
class LoadGroupsEvent extends ScriptQuantityEvent {
  final String exchange;
  const LoadGroupsEvent(this.exchange);
  @override
  List<Object?> get props => [exchange];
}
class LoadScriptQuantitiesEvent extends ScriptQuantityEvent {
  final String exchange;
  final String group;
  const LoadScriptQuantitiesEvent({
    required this.exchange,
    required this.group,
  });
  @override
  List<Object?> get props => [exchange, group];
}
class ResetFiltersEvent extends ScriptQuantityEvent {
  const ResetFiltersEvent();
}
