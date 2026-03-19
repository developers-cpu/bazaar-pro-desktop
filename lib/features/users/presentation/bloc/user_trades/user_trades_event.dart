import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class UserTradesEvent extends Equatable {
  const UserTradesEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserTrades extends UserTradesEvent {
  final String userId;
  const LoadUserTrades(this.userId);
  @override
  List<Object?> get props => [userId];
}

class FilterUserTrades extends UserTradesEvent {
  final DateTimeRange? dateRange;
  final String? exchange;
  final String? symbol;
  final String? status;
  const FilterUserTrades({
    this.dateRange,
    this.exchange,
    this.symbol,
    this.status,
  });
  @override
  List<Object?> get props => [dateRange, exchange, symbol, status];
}