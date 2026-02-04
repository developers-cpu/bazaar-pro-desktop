import 'package:flutter/material.dart';
import '../../../domain/entities/user_trades/user_trade.dart';
import '../../../domain/entities/user_trades/user_trades_metadata.dart';
abstract class UserTradesState {}
class UserTradesInitial extends UserTradesState {}
class UserTradesLoading extends UserTradesState {}
class UserTradesLoaded extends UserTradesState {
  final List<UserTrade> allTrades;
  final List<UserTrade> filteredTrades;
  final DateTimeRange? selectedDateRange;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String? selectedStatus;
  final UserTradesMetadata? metadata;
  UserTradesLoaded({
    required this.allTrades,
    required this.filteredTrades,
    this.selectedDateRange,
    this.selectedExchange,
    this.selectedSymbol,
    this.selectedStatus,
    this.metadata,
  });
  UserTradesLoaded copyWith({
    List<UserTrade>? allTrades,
    List<UserTrade>? filteredTrades,
    DateTimeRange? selectedDateRange,
    String? selectedExchange,
    String? selectedSymbol,
    String? selectedStatus,
    UserTradesMetadata? metadata,
  }) {
    return UserTradesLoaded(
      allTrades: allTrades ?? this.allTrades,
      filteredTrades: filteredTrades ?? this.filteredTrades,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      metadata: metadata ?? this.metadata,
    );
  }
}
class UserTradesError extends UserTradesState {
  final String message;
  UserTradesError(this.message);
}
