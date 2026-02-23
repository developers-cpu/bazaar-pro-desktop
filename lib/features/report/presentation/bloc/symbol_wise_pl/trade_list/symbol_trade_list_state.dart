import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/symbol_trade_log.dart';
abstract class SymbolTradeListState extends Equatable {
  const SymbolTradeListState();
  @override
  List<Object?> get props => [];
}
class SymbolTradeListInitial extends SymbolTradeListState {}
class SymbolTradeListLoading extends SymbolTradeListState {}
class SymbolTradeListLoaded extends SymbolTradeListState {
  final List<SymbolTradeLog> tradeLogs;
  final DateTimeRange? selectedDateRange;
  final String? selectedUser;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String? selectedType;
  final List<String> users;
  final List<String> exchanges;
  final List<String> symbols;
  final List<String> types;
  const SymbolTradeListLoaded({
    required this.tradeLogs,
    this.selectedDateRange,
    this.selectedUser,
    this.selectedExchange,
    this.selectedSymbol,
    this.selectedType,
    this.users = const [],
    this.exchanges = const [],
    this.symbols = const [],
    this.types = const [],
  });
  SymbolTradeListLoaded copyWith({
    List<SymbolTradeLog>? tradeLogs,
    DateTimeRange? selectedDateRange,
    String? selectedUser,
    String? selectedExchange,
    String? selectedSymbol,
    String? selectedType,
    List<String>? users,
    List<String>? exchanges,
    List<String>? symbols,
    List<String>? types,
  }) {
    return SymbolTradeListLoaded(
      tradeLogs: tradeLogs ?? this.tradeLogs,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      selectedUser: selectedUser ?? this.selectedUser,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      selectedType: selectedType ?? this.selectedType,
      users: users ?? this.users,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
      types: types ?? this.types,
    );
  }
  @override
  List<Object?> get props => [
    tradeLogs,
    selectedDateRange,
    selectedUser,
    selectedExchange,
    selectedSymbol,
    selectedType,
    users,
    exchanges,
    symbols,
    types,
  ];
}
class SymbolTradeListError extends SymbolTradeListState {
  final String message;
  const SymbolTradeListError(this.message);
  @override
  List<Object?> get props => [message];
}
