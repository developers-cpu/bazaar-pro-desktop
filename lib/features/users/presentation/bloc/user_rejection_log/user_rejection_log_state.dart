import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/user_rejection_log.dart';

abstract class UserRejectionLogState extends Equatable {
  const UserRejectionLogState();

  @override
  List<Object?> get props => [];
}

class UserRejectionLogLoading extends UserRejectionLogState {}

class UserRejectionLogLoaded extends UserRejectionLogState {
  final List<UserRejectionLog> allLogs;
  final List<UserRejectionLog> filteredLogs;

  final DateTimeRange? selectedDateRange;
  final String? selectedExchange;
  final String? selectedSymbol;

  const UserRejectionLogLoaded({
    required this.allLogs,
    required this.filteredLogs,
    this.selectedDateRange,
    this.selectedExchange,
    this.selectedSymbol,
  });

  UserRejectionLogLoaded copyWith({
    List<UserRejectionLog>? allLogs,
    List<UserRejectionLog>? filteredLogs,
    DateTimeRange? selectedDateRange,
    String? selectedExchange,
    String? selectedSymbol,
  }) {
    return UserRejectionLogLoaded(
      allLogs: allLogs ?? this.allLogs,
      filteredLogs: filteredLogs ?? this.filteredLogs,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
    );
  }

  @override
  List<Object?> get props => [
    allLogs,
    filteredLogs,
    selectedDateRange,
    selectedExchange,
    selectedSymbol,
  ];
}

class UserRejectionLogError extends UserRejectionLogState {
  final String message;
  const UserRejectionLogError(this.message);

  @override
  List<Object?> get props => [message];
}
