import 'package:bazarpro/features/users/domain/entities/user_rejection_log/user_rejection_log.dart';
import 'package:bazarpro/features/users/domain/entities/user_rejection_log/user_rejection_log_metadata.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
abstract class UserRejectionLogState extends Equatable {
  const UserRejectionLogState();
  @override
  List<Object?> get props => [];
}
class UserRejectionLogInitial extends UserRejectionLogState {}
class UserRejectionLogLoading extends UserRejectionLogState {}
class UserRejectionLogLoaded extends UserRejectionLogState {
  final List<UserRejectionLog> logs;
  final List<UserRejectionLog> filteredLogs;
  final UserRejectionLogMetadata? metadata;
  final DateTimeRange? selectedDateRange;
  final String? selectedExchange;
  final String? selectedSymbol;
  const UserRejectionLogLoaded({
    required this.logs,
    required this.filteredLogs,
    this.metadata,
    this.selectedDateRange,
    this.selectedExchange,
    this.selectedSymbol,
  });
  UserRejectionLogLoaded copyWith({
    List<UserRejectionLog>? logs,
    List<UserRejectionLog>? filteredLogs,
    UserRejectionLogMetadata? metadata,
    DateTimeRange? selectedDateRange,
    String? selectedExchange,
    String? selectedSymbol,
  }) {
    return UserRejectionLogLoaded(
      logs: logs ?? this.logs,
      filteredLogs: filteredLogs ?? this.filteredLogs,
      metadata: metadata ?? this.metadata,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
    );
  }
  @override
  List<Object?> get props => [
    logs,
    filteredLogs,
    metadata,
    selectedDateRange,
    selectedExchange,
    selectedSymbol,
  ];
}
class UserRejectionLogError extends UserRejectionLogState {
  final String message;
  const UserRejectionLogError(this.message);
  @override
  List<Object> get props => [message];
}
