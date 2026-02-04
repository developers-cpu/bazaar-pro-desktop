import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
abstract class ActivityReportEvent extends Equatable {
  const ActivityReportEvent();
  @override
  List<Object?> get props => [];
}
class LoadActivityReport extends ActivityReportEvent {
  const LoadActivityReport();
}
class FilterActivityReport extends ActivityReportEvent {
  final String? user;
  final DateTimeRange? dateRange;
  final String? editUserType;
  const FilterActivityReport({this.user, this.dateRange, this.editUserType});
  @override
  List<Object?> get props => [user, dateRange, editUserType];
}
class ResetActivityReportFilters extends ActivityReportEvent {
  const ResetActivityReportFilters();
}
