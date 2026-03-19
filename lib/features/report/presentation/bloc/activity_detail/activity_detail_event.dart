import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ActivityDetailEvent extends Equatable {
  const ActivityDetailEvent();
  @override
  List<Object?> get props => [];
}

class FetchActivityDetails extends ActivityDetailEvent {
  final String activityName;
  final String? valueType;
  const FetchActivityDetails({required this.activityName, this.valueType});
  @override
  List<Object?> get props => [activityName, valueType];
}

class FilterActivityDetails extends ActivityDetailEvent {
  final DateTimeRange? dateRange;
  const FilterActivityDetails({this.dateRange});
  @override
  List<Object?> get props => [dateRange];
}