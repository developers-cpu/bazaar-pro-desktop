import 'package:equatable/equatable.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';

abstract class PendingOrdersState extends Equatable {
  const PendingOrdersState();
  @override
  List<Object?> get props => [];
}

class PendingOrdersInitial extends PendingOrdersState {
  const PendingOrdersInitial();
}

class PendingOrdersLoading extends PendingOrdersState {
  const PendingOrdersLoading();
}

class PendingOrdersLoaded extends PendingOrdersState {
  final List<PendingOrder> allOrders;
  final List<PendingOrder> filteredOrders;
  final List<String> clients;
  final List<String> exchanges;
  final List<String> symbols;
  final List<String> types;
  final String? selectedClient;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String? selectedType;
  final String? sortColumn;
  final bool sortAscending;
  final String? selectedOrderId;
  final int totalRecords;
  const PendingOrdersLoaded({
    required this.allOrders,
    required this.filteredOrders,
    required this.clients,
    required this.exchanges,
    required this.symbols,
    required this.types,
    this.selectedClient,
    this.selectedExchange,
    this.selectedSymbol,
    this.selectedType,
    this.sortColumn,
    this.sortAscending = true,
    this.selectedOrderId,
    required this.totalRecords,
  });
  PendingOrdersLoaded copyWith({
    List<PendingOrder>? allOrders,
    List<PendingOrder>? filteredOrders,
    List<String>? clients,
    List<String>? exchanges,
    List<String>? symbols,
    List<String>? types,
    String? selectedClient,
    String? selectedExchange,
    String? selectedSymbol,
    String? selectedType,
    String? sortColumn,
    bool? sortAscending,
    String? selectedOrderId,
    int? totalRecords,
    bool clearClient = false,
    bool clearExchange = false,
    bool clearSymbol = false,
    bool clearType = false,
  }) {
    return PendingOrdersLoaded(
      allOrders: allOrders ?? this.allOrders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      clients: clients ?? this.clients,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
      types: types ?? this.types,
      selectedClient: clearClient
          ? null
          : (selectedClient ?? this.selectedClient),
      selectedExchange: clearExchange
          ? null
          : (selectedExchange ?? this.selectedExchange),
      selectedSymbol: clearSymbol
          ? null
          : (selectedSymbol ?? this.selectedSymbol),
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedOrderId: selectedOrderId ?? this.selectedOrderId,
      totalRecords: totalRecords ?? this.totalRecords,
    );
  }

  @override
  List<Object?> get props => [
    allOrders,
    filteredOrders,
    clients,
    exchanges,
    symbols,
    types,
    selectedClient,
    selectedExchange,
    selectedSymbol,
    selectedType,
    sortColumn,
    sortAscending,
    selectedOrderId,
    totalRecords,
  ];
}

class PendingOrdersError extends PendingOrdersState {
  final String message;
  const PendingOrdersError(this.message);
  @override
  List<Object?> get props => [message];
}

class PendingOrdersExporting extends PendingOrdersState {
  final String exportType;
  const PendingOrdersExporting(this.exportType);
  @override
  List<Object?> get props => [exportType];
}

class PendingOrdersExportSuccess extends PendingOrdersState {
  final String message;
  final String filePath;
  const PendingOrdersExportSuccess({
    required this.message,
    required this.filePath,
  });
  @override
  List<Object?> get props => [message, filePath];
}
