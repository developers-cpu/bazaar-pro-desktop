import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/user_trade.dart';

abstract class UserTradesState extends Equatable {
  const UserTradesState();

  @override
  List<Object?> get props => [];
}

class UserTradesInitial extends UserTradesState {}

class UserTradesLoading extends UserTradesState {}

class UserTradesLoaded extends UserTradesState {
  final List<UserTrade> allTrades;
  final List<UserTrade> filteredTrades;
  final DateTimeRange? selectedDateRange;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String? selectedStatus;

  const UserTradesLoaded({
    required this.allTrades,
    required this.filteredTrades,
    this.selectedDateRange,
    this.selectedExchange,
    this.selectedSymbol,
    this.selectedStatus,
  });

  @override
  List<Object?> get props => [
    allTrades,
    filteredTrades,
    selectedDateRange,
    selectedExchange,
    selectedSymbol,
    selectedStatus,
  ];
}

class UserTradesError extends UserTradesState {
  final String message;

  const UserTradesError(this.message);

  @override
  List<Object?> get props => [message];
}
