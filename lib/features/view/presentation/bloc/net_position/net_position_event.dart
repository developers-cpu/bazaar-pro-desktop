import 'package:equatable/equatable.dart';

/// Base event for Net Position BLoC
abstract class NetPositionEvent extends Equatable {
  const NetPositionEvent();

  @override
  List<Object?> get props => [];
}

class LoadNetPositionsEvent extends NetPositionEvent {
  const LoadNetPositionsEvent();
}

class LoadFilterDataEvent extends NetPositionEvent {
  const LoadFilterDataEvent();
}

class ApplyFiltersEvent extends NetPositionEvent {
  final String? userType;
  final String? client;
  final String? exchange;
  final String? symbol;

  const ApplyFiltersEvent({
    this.userType,
    this.client,
    this.exchange,
    this.symbol,
  });

  @override
  List<Object?> get props => [
    userType,
    client,
    exchange,
    symbol,
  ];
}

class ResetFiltersEvent extends NetPositionEvent {
  const ResetFiltersEvent();
}

class SelectPositionEvent extends NetPositionEvent {
  final String positionId;

  const SelectPositionEvent(this.positionId);

  @override
  List<Object?> get props => [positionId];
}

class SortPositionsByColumnEvent extends NetPositionEvent {
  final String columnId;
  final bool ascending;

  const SortPositionsByColumnEvent({
    required this.columnId,
    required this.ascending,
  });

  @override
  List<Object?> get props => [columnId, ascending];
}

class ExportNetPositionsToPdfEvent extends NetPositionEvent {
  const ExportNetPositionsToPdfEvent();
}

class ExportNetPositionsToExcelEvent extends NetPositionEvent {
  const ExportNetPositionsToExcelEvent();
}

class LoadPositionDetailsEvent extends NetPositionEvent {
  final String symbol;
  final String userName;

  const LoadPositionDetailsEvent({
    required this.symbol,
    required this.userName,
  });

  @override
  List<Object?> get props => [symbol, userName];
}