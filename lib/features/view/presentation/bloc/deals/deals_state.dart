import 'package:equatable/equatable.dart';

import '../../../domain/entities/deals.dart';


/// Base state for Deals BLoC
abstract class DealsState extends Equatable {
  const DealsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DealsInitial extends DealsState {
  const DealsInitial();
}

/// Loading state
class DealsLoading extends DealsState {
  const DealsLoading();
}

/// Loaded state
class DealsLoaded extends DealsState {
  final List<Deal> deals;
  final List<Deal> filteredDeals;
  final int totalRecords;
  final String? selectedDealId;
  final String? sortColumn;
  final bool sortAscending;

  // Filter values
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedClient;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String? selectedOrderType;
  final String? selectedStatus;

  // Filter options
  final List<String> clients;
  final List<String> exchanges;
  final List<String> symbols;
  final List<String> orderTypes;
  final List<String> statuses;

  const DealsLoaded({
    required this.deals,
    required this.filteredDeals,
    required this.totalRecords,
    this.selectedDealId,
    this.sortColumn,
    this.sortAscending = true,
    this.startDate,
    this.endDate,
    this.selectedClient,
    this.selectedExchange,
    this.selectedSymbol,
    this.selectedOrderType,
    this.selectedStatus,
    this.clients = const [],
    this.exchanges = const [],
    this.symbols = const [],
    this.orderTypes = const [],
    this.statuses = const [],
  });

  @override
  List<Object?> get props => [
    deals,
    filteredDeals,
    totalRecords,
    selectedDealId,
    sortColumn,
    sortAscending,
    startDate,
    endDate,
    selectedClient,
    selectedExchange,
    selectedSymbol,
    selectedOrderType,
    selectedStatus,
    clients,
    exchanges,
    symbols,
    orderTypes,
    statuses,
  ];

  DealsLoaded copyWith({
    List<Deal>? deals,
    List<Deal>? filteredDeals,
    int? totalRecords,
    String? selectedDealId,
    String? sortColumn,
    bool? sortAscending,
    DateTime? startDate,
    DateTime? endDate,
    String? selectedClient,
    String? selectedExchange,
    String? selectedSymbol,
    String? selectedOrderType,
    String? selectedStatus,
    List<String>? clients,
    List<String>? exchanges,
    List<String>? symbols,
    List<String>? orderTypes,
    List<String>? statuses,
  }) {
    return DealsLoaded(
      deals: deals ?? this.deals,
      filteredDeals: filteredDeals ?? this.filteredDeals,
      totalRecords: totalRecords ?? this.totalRecords,
      selectedDealId: selectedDealId ?? this.selectedDealId,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedClient: selectedClient ?? this.selectedClient,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      clients: clients ?? this.clients,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
      orderTypes: orderTypes ?? this.orderTypes,
      statuses: statuses ?? this.statuses,
    );
  }
}

/// Error state
class DealsError extends DealsState {
  final String message;

  const DealsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Export success state
class DealsExportSuccess extends DealsState {
  final String message;
  final String filePath;

  const DealsExportSuccess({
    required this.message,
    required this.filePath,
  });

  @override
  List<Object?> get props => [message, filePath];
}