import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SymbolTradeListEvent extends Equatable {
  const SymbolTradeListEvent();

  @override
  List<Object?> get props => [];
}

class LoadSymbolTradeList extends SymbolTradeListEvent {
  final String? symbol;
  final String? exchange;

  const LoadSymbolTradeList({
    this.symbol,
    this.exchange,
    this.dateRange,
    this.user,
    this.type,
  });

  final DateTimeRange? dateRange;
  final String? user;
  final String? type;

  @override
  List<Object?> get props => [symbol, exchange, dateRange, user, type];
}

class FilterSymbolTradeList extends SymbolTradeListEvent {
  final String? user;
  final String? exchange;
  final String? symbol;
  final String? type;
  final DateTimeRange? dateRange;

  const FilterSymbolTradeList({
    this.user,
    this.exchange,
    this.symbol,
    this.type,
    this.dateRange,
  });

  @override
  List<Object?> get props => [user, exchange, symbol, type, dateRange];
}

class ResetSymbolTradeListFilters extends SymbolTradeListEvent {
  const ResetSymbolTradeListFilters();
}
