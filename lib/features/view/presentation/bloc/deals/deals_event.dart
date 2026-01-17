import 'package:equatable/equatable.dart';

/// Base event for Deals BLoC
abstract class DealsEvent extends Equatable {
  const DealsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDealsEvent extends DealsEvent {
  const LoadDealsEvent();
}

class LoadFilterDataEvent extends DealsEvent {
  const LoadFilterDataEvent();
}

class ApplyFiltersEvent extends DealsEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? client;
  final String? exchange;
  final String? symbol;
  final String? orderType;
  final String? status;

  const ApplyFiltersEvent({
    this.startDate,
    this.endDate,
    this.client,
    this.exchange,
    this.symbol,
    this.orderType,
    this.status,
  });

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    client,
    exchange,
    symbol,
    orderType,
    status,
  ];
}

class ResetFiltersEvent extends DealsEvent {
  const ResetFiltersEvent();
}

class SelectDealEvent extends DealsEvent {
  final String dealId;

  const SelectDealEvent(this.dealId);

  @override
  List<Object?> get props => [dealId];
}

class SortDealsByColumnEvent extends DealsEvent {
  final String columnId;
  final bool ascending;

  const SortDealsByColumnEvent({
    required this.columnId,
    required this.ascending,
  });

  @override
  List<Object?> get props => [columnId, ascending];
}

class ExportDealsToPdfEvent extends DealsEvent {
  const ExportDealsToPdfEvent();
}

class ExportDealsToExcelEvent extends DealsEvent {
  const ExportDealsToExcelEvent();
}

class UpdateDateRangeEvent extends DealsEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const UpdateDateRangeEvent({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}