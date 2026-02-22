import 'package:bazarpro/features/report/domain/entities/activity_report.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ActivityReportState extends Equatable {
  const ActivityReportState();
  @override
  List<Object?> get props => [];
}

class ActivityReportInitial extends ActivityReportState {}

class ActivityReportLoading extends ActivityReportState {}

class ActivityReportLoaded extends ActivityReportState {
  final List<ActivityReport> reports;
  final List<String> users;
  final String? selectedUserType;
  final String? selectedUser;
  final DateTimeRange? selectedDateRange;
  final String? selectedEditUserType;
  const ActivityReportLoaded({
    required this.reports,
    this.users = const [],
    this.selectedUserType,
    this.selectedUser,
    this.selectedDateRange,
    this.selectedEditUserType,
  });
  ActivityReportLoaded copyWith({
    List<ActivityReport>? reports,
    List<String>? users,
    String? selectedUserType,
    String? selectedUser,
    DateTimeRange? selectedDateRange,
    String? selectedEditUserType,
  }) {
    return ActivityReportLoaded(
      reports: reports ?? this.reports,
      users: users ?? this.users,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      selectedUser: selectedUser ?? this.selectedUser,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      selectedEditUserType: selectedEditUserType ?? this.selectedEditUserType,
    );
  }

  @override
  List<Object?> get props => [
    reports,
    users,
    selectedUserType,
    selectedUser,
    selectedDateRange,
    selectedEditUserType,
  ];
}

class ActivityReportError extends ActivityReportState {
  final String message;
  const ActivityReportError({required this.message});
  @override
  List<Object> get props => [message];
}
