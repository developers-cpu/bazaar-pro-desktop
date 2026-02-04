import 'package:equatable/equatable.dart';
import '../../../domain/entities/script_quantity/script_quantity.dart';
abstract class ScriptQuantityState extends Equatable {
  const ScriptQuantityState();
  @override
  List<Object?> get props => [];
}
class ScriptQuantityInitial extends ScriptQuantityState {
  const ScriptQuantityInitial();
}
class ScriptQuantityLoading extends ScriptQuantityState {
  const ScriptQuantityLoading();
}
class ScriptQuantityFiltersLoaded extends ScriptQuantityState {
  final List<String> exchanges;
  final List<String> groups;
  final String? selectedExchange;
  final String? selectedGroup;
  const ScriptQuantityFiltersLoaded({
    required this.exchanges,
    this.groups = const [],
    this.selectedExchange,
    this.selectedGroup,
  });
  @override
  List<Object?> get props => [exchanges, groups, selectedExchange, selectedGroup];
  ScriptQuantityFiltersLoaded copyWith({
    List<String>? exchanges,
    List<String>? groups,
    String? selectedExchange,
    String? selectedGroup,
  }) {
    return ScriptQuantityFiltersLoaded(
      exchanges: exchanges ?? this.exchanges,
      groups: groups ?? this.groups,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedGroup: selectedGroup ?? this.selectedGroup,
    );
  }
}
class ScriptQuantityDataLoaded extends ScriptQuantityState {
  final List<ScriptQuantity> quantities;
  final String exchange;
  final String group;
  final int totalRecords;
  const ScriptQuantityDataLoaded({
    required this.quantities,
    required this.exchange,
    required this.group,
    required this.totalRecords,
  });
  @override
  List<Object?> get props => [quantities, exchange, group, totalRecords];
}
class ScriptQuantityError extends ScriptQuantityState {
  final String message;
  const ScriptQuantityError(this.message);
  @override
  List<Object?> get props => [message];
}
