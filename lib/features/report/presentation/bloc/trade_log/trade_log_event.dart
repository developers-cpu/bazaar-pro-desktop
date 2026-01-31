import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TradeLogEvent extends Equatable {
  const TradeLogEvent();

  @override
  List<Object?> get props => [];
}

class LoadTradeLogsEvent extends TradeLogEvent {
  const LoadTradeLogsEvent();
}

class FilterTradeLogsEvent extends TradeLogEvent {
  final DateTimeRange? dateRange;
  final String? user;
  final String? exchange;
  final String? symbol;

  const FilterTradeLogsEvent({
    this.dateRange,
    this.user,
    this.exchange,
    this.symbol,
  });

  @override
  List<Object?> get props => [dateRange, user, exchange, symbol];
}

class SortTradeLogsEvent extends TradeLogEvent {
  final String columnId;
  final bool ascending;

  const SortTradeLogsEvent({required this.columnId, required this.ascending});

  @override
  List<Object?> get props => [columnId, ascending];
}

class ResetTradeLogsFiltersEvent extends TradeLogEvent {
  const ResetTradeLogsFiltersEvent();
}
