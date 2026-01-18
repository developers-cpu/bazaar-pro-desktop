import 'package:equatable/equatable.dart';

import '../../../domain/entities/script_master.dart';

/// Base state for Script Master BLoC
abstract class ScriptMasterState extends Equatable {
  const ScriptMasterState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ScriptMasterInitial extends ScriptMasterState {
  const ScriptMasterInitial();
}

/// Loading state
class ScriptMasterLoading extends ScriptMasterState {
  const ScriptMasterLoading();
}

/// Loaded state
class ScriptMasterLoaded extends ScriptMasterState {
  final List<ScriptMaster> scripts;
  final List<ScriptMaster> filteredScripts;
  final int totalRecords;
  final String? selectedScriptId;
  final String? sortColumn;
  final bool sortAscending;

  // Filter values
  final String? selectedExchange;
  final String? selectedSymbol;

  // Filter options
  final List<String> exchanges;
  final List<String> symbols;

  const ScriptMasterLoaded({
    required this.scripts,
    required this.filteredScripts,
    required this.totalRecords,
    this.selectedScriptId,
    this.sortColumn,
    this.sortAscending = true,
    this.selectedExchange,
    this.selectedSymbol,
    this.exchanges = const [],
    this.symbols = const [],
  });

  @override
  List<Object?> get props => [
    scripts,
    filteredScripts,
    totalRecords,
    selectedScriptId,
    sortColumn,
    sortAscending,
    selectedExchange,
    selectedSymbol,
    exchanges,
    symbols,
  ];

  ScriptMasterLoaded copyWith({
    List<ScriptMaster>? scripts,
    List<ScriptMaster>? filteredScripts,
    int? totalRecords,
    String? selectedScriptId,
    String? sortColumn,
    bool? sortAscending,
    String? selectedExchange,
    String? selectedSymbol,
    List<String>? exchanges,
    List<String>? symbols,
  }) {
    return ScriptMasterLoaded(
      scripts: scripts ?? this.scripts,
      filteredScripts: filteredScripts ?? this.filteredScripts,
      totalRecords: totalRecords ?? this.totalRecords,
      selectedScriptId: selectedScriptId ?? this.selectedScriptId,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
    );
  }
}

/// Error state
class ScriptMasterError extends ScriptMasterState {
  final String message;

  const ScriptMasterError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Export success state
class ScriptMasterExportSuccess extends ScriptMasterState {
  final String message;
  final String filePath;

  const ScriptMasterExportSuccess({
    required this.message,
    required this.filePath,
  });

  @override
  List<Object?> get props => [message, filePath];
}