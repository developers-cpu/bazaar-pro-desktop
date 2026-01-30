import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class UserRejectionLogEvent extends Equatable {
  const UserRejectionLogEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserRejectionLogs extends UserRejectionLogEvent {
  final String userId;
  const LoadUserRejectionLogs(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FilterUserRejectionLogs extends UserRejectionLogEvent {
  final DateTimeRange? dateRange;
  final String? exchange;
  final String? symbol;

  const FilterUserRejectionLogs({this.dateRange, this.exchange, this.symbol});

  @override
  List<Object?> get props => [dateRange, exchange, symbol];
}
