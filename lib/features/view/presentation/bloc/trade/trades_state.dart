import 'package:equatable/equatable.dart';
import '../../../domain/entities/trades/trade.dart';

abstract class TradesState extends Equatable {
  const TradesState();

  @override
  List<Object?> get props => [];
}

class TradesInitial extends TradesState {
  const TradesInitial();
}

class TradesLoading extends TradesState {
  const TradesLoading();
}

class TradesLoaded extends TradesState {
  final List<Trade> trades;
  final List<Trade> filteredTrades;
  final int totalRecords;
  final String? selectedTradeId;
  final String? sortColumn;
  final bool sortAscending;

  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedClient;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String? selectedOrderType;

  final List<String> clients;
  final List<String> exchanges;
  final List<String> symbols;
  final List<String> orderTypes;

  const TradesLoaded({
    required this.trades,
    required this.filteredTrades,
    required this.totalRecords,
    this.selectedTradeId,
    this.sortColumn,
    this.sortAscending = true,
    this.startDate,
    this.endDate,
    this.selectedClient,
    this.selectedExchange,
    this.selectedSymbol,
    this.selectedOrderType,
    this.clients = const [],
    this.exchanges = const [],
    this.symbols = const [],
    this.orderTypes = const [],
  });

  @override
  List<Object?> get props => [
    trades,
    filteredTrades,
    totalRecords,
    selectedTradeId,
    sortColumn,
    sortAscending,
    startDate,
    endDate,
    selectedClient,
    selectedExchange,
    selectedSymbol,
    selectedOrderType,
    clients,
    exchanges,
    symbols,
    orderTypes,
  ];

  TradesLoaded copyWith({
    List<Trade>? trades,
    List<Trade>? filteredTrades,
    int? totalRecords,
    String? selectedTradeId,
    String? sortColumn,
    bool? sortAscending,
    DateTime? startDate,
    DateTime? endDate,
    String? selectedClient,
    String? selectedExchange,
    String? selectedSymbol,
    String? selectedOrderType,
    List<String>? clients,
    List<String>? exchanges,
    List<String>? symbols,
    List<String>? orderTypes,
  }) {
    return TradesLoaded(
      trades: trades ?? this.trades,
      filteredTrades: filteredTrades ?? this.filteredTrades,
      totalRecords: totalRecords ?? this.totalRecords,
      selectedTradeId: selectedTradeId ?? this.selectedTradeId,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedClient: selectedClient ?? this.selectedClient,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      clients: clients ?? this.clients,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
      orderTypes: orderTypes ?? this.orderTypes,
    );
  }
}

class TradesError extends TradesState {
  final String message;

  const TradesError(this.message);

  @override
  List<Object?> get props => [message];
}

class TradesExportSuccess extends TradesState {
  final String message;
  final String filePath;

  const TradesExportSuccess({
    required this.message,
    required this.filePath,
  });

  @override
  List<Object?> get props => [message, filePath];
}