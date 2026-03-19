import 'package:equatable/equatable.dart';
import '../../../domain/entities/rejection_log/rejection_log.dart';

abstract class RejectionLogState extends Equatable {
  const RejectionLogState();
  @override
  List<Object?> get props => [];
}

class RejectionLogInitial extends RejectionLogState {
  const RejectionLogInitial();
}

class RejectionLogLoading extends RejectionLogState {
  const RejectionLogLoading();
}

class RejectionLogLoaded extends RejectionLogState {
  final List<RejectionLog> logs;
  final List<RejectionLog> filteredLogs;
  final int totalRecords;
  final String? sortColumn;
  final bool sortAscending;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedClient;
  final String? selectedExchange;
  final String? selectedSymbol;
  final List<String> clients;
  final List<String> exchanges;
  final List<String> symbols;
  const RejectionLogLoaded({
    required this.logs,
    required this.filteredLogs,
    required this.totalRecords,
    this.sortColumn,
    this.sortAscending = true,
    this.startDate,
    this.endDate,
    this.selectedClient,
    this.selectedExchange,
    this.selectedSymbol,
    this.clients = const [],
    this.exchanges = const [],
    this.symbols = const [],
  });
  @override
  List<Object?> get props => [
    logs,
    filteredLogs,
    totalRecords,
    sortColumn,
    sortAscending,
    startDate,
    endDate,
    selectedClient,
    selectedExchange,
    selectedSymbol,
    clients,
    exchanges,
    symbols,
  ];
  RejectionLogLoaded copyWith({
    List<RejectionLog>? logs,
    List<RejectionLog>? filteredLogs,
    int? totalRecords,
    String? sortColumn,
    bool? sortAscending,
    DateTime? startDate,
    DateTime? endDate,
    String? selectedClient,
    String? selectedExchange,
    String? selectedSymbol,
    List<String>? clients,
    List<String>? exchanges,
    List<String>? symbols,
  }) {
    return RejectionLogLoaded(
      logs: logs ?? this.logs,
      filteredLogs: filteredLogs ?? this.filteredLogs,
      totalRecords: totalRecords ?? this.totalRecords,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedClient: selectedClient ?? this.selectedClient,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      clients: clients ?? this.clients,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
    );
  }
}

class RejectionLogError extends RejectionLogState {
  final String message;
  const RejectionLogError(this.message);
  @override
  List<Object?> get props => [message];
}

class RejectionLogExportSuccess extends RejectionLogState {
  final String message;
  final String filePath;
  const RejectionLogExportSuccess({
    required this.message,
    required this.filePath,
  });
  @override
  List<Object?> get props => [message, filePath];
}