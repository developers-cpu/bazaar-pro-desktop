import 'package:equatable/equatable.dart';

/// Base event for Script Quantity BLoC
abstract class ScriptQuantityEvent extends Equatable {
  const ScriptQuantityEvent();

  @override
  List<Object?> get props => [];
}

/// Load initial filters (exchanges)
class LoadFiltersEvent extends ScriptQuantityEvent {
  const LoadFiltersEvent();
}

/// Load groups based on selected exchange
class LoadGroupsEvent extends ScriptQuantityEvent {
  final String exchange;

  const LoadGroupsEvent(this.exchange);

  @override
  List<Object?> get props => [exchange];
}

/// Load script quantities with filters
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

/// Reset all filters
class ResetFiltersEvent extends ScriptQuantityEvent {
  const ResetFiltersEvent();
}