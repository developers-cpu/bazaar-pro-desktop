import 'package:equatable/equatable.dart';

abstract class PendingOrdersEvent extends Equatable {
  const PendingOrdersEvent();
  @override
  List<Object?> get props => [];
}

class LoadPendingOrdersEvent extends PendingOrdersEvent {
  const LoadPendingOrdersEvent();
}

class FilterByClientEvent extends PendingOrdersEvent {
  final String? client;
  const FilterByClientEvent(this.client);
  @override
  List<Object?> get props => [client];
}

class FilterByExchangeEvent extends PendingOrdersEvent {
  final String? exchange;
  const FilterByExchangeEvent(this.exchange);
  @override
  List<Object?> get props => [exchange];
}

class FilterBySymbolEvent extends PendingOrdersEvent {
  final String? symbol;
  const FilterBySymbolEvent(this.symbol);
  @override
  List<Object?> get props => [symbol];
}

class FilterByTypeEvent extends PendingOrdersEvent {
  final String? type;
  const FilterByTypeEvent(this.type);
  @override
  List<Object?> get props => [type];
}

class ApplyFiltersEvent extends PendingOrdersEvent {
  final String? client;
  final String? exchange;
  final String? symbol;
  final String? type;
  const ApplyFiltersEvent({this.client, this.exchange, this.symbol, this.type});
  @override
  List<Object?> get props => [client, exchange, symbol, type];
}

class ResetFiltersEvent extends PendingOrdersEvent {
  const ResetFiltersEvent();
}

class SortByColumnEvent extends PendingOrdersEvent {
  final String columnId;
  final bool ascending;
  const SortByColumnEvent({required this.columnId, required this.ascending});
  @override
  List<Object?> get props => [columnId, ascending];
}

class ExportToPdfEvent extends PendingOrdersEvent {
  const ExportToPdfEvent();
}

class ExportToExcelEvent extends PendingOrdersEvent {
  const ExportToExcelEvent();
}

class SelectOrderEvent extends PendingOrdersEvent {
  final String? orderId;
  const SelectOrderEvent(this.orderId);
  @override
  List<Object?> get props => [orderId];
}
