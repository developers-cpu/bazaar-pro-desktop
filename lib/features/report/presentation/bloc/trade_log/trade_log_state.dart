import 'package:bazarpro/features/report/domain/entities/trade_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TradeLogState extends Equatable {
  const TradeLogState();
  @override
  List<Object?> get props => [];
}

class TradeLogInitial extends TradeLogState {}

class TradeLogLoading extends TradeLogState {}

class TradeLogLoaded extends TradeLogState {
  final List<TradeLog> tradeLogs;
  final List<TradeLog> filteredTradeLogs;
  final DateTimeRange? selectedDateRange;
  final String? selectedUser;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String sortColumn;
  final bool sortAscending;
  final List<String> users;
  final List<String> exchanges;
  final List<String> symbols;
  const TradeLogLoaded({
    required this.tradeLogs,
    required this.filteredTradeLogs,
    this.selectedDateRange,
    this.selectedUser,
    this.selectedExchange,
    this.selectedSymbol,
    this.sortColumn = 'updateTime',
    this.sortAscending = false,
    this.users = const [],
    this.exchanges = const [],
    this.symbols = const [],
  });
  TradeLogLoaded copyWith({
    List<TradeLog>? tradeLogs,
    List<TradeLog>? filteredTradeLogs,
    DateTimeRange? selectedDateRange,
    String? selectedUser,
    String? selectedExchange,
    String? selectedSymbol,
    String? sortColumn,
    bool? sortAscending,
    List<String>? users,
    List<String>? exchanges,
    List<String>? symbols,
  }) {
    return TradeLogLoaded(
      tradeLogs: tradeLogs ?? this.tradeLogs,
      filteredTradeLogs: filteredTradeLogs ?? this.filteredTradeLogs,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      selectedUser: selectedUser ?? this.selectedUser,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      users: users ?? this.users,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
    );
  }

  @override
  List<Object?> get props => [
    tradeLogs,
    filteredTradeLogs,
    selectedDateRange,
    selectedUser,
    selectedExchange,
    selectedSymbol,
    sortColumn,
    sortAscending,
    users,
    exchanges,
    symbols,
  ];
}

class TradeLogError extends TradeLogState {
  final String message;
  const TradeLogError({required this.message});
  @override
  List<Object?> get props => [message];
}
