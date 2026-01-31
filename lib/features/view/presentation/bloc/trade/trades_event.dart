import 'package:equatable/equatable.dart';

abstract class TradesEvent extends Equatable {
  const TradesEvent();

  @override
  List<Object?> get props => [];
}

class LoadTradesEvent extends TradesEvent {
  const LoadTradesEvent();
}

class LoadFilterDataEvent extends TradesEvent {
  const LoadFilterDataEvent();
}

class ApplyFiltersEvent extends TradesEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? client;
  final String? exchange;
  final String? symbol;
  final String? orderType;

  const ApplyFiltersEvent({
    this.startDate,
    this.endDate,
    this.client,
    this.exchange,
    this.symbol,
    this.orderType,
  });

  @override
  List<Object?> get props => [startDate, endDate, client, exchange, symbol, orderType];
}

class ResetFiltersEvent extends TradesEvent {
  const ResetFiltersEvent();
}

class SelectTradeEvent extends TradesEvent {
  final String tradeId;

  const SelectTradeEvent(this.tradeId);

  @override
  List<Object?> get props => [tradeId];
}

class SortTradesByColumnEvent extends TradesEvent {
  final String columnId;
  final bool ascending;

  const SortTradesByColumnEvent({
    required this.columnId,
    required this.ascending,
  });

  @override
  List<Object?> get props => [columnId, ascending];
}

class ExportTradesToPdfEvent extends TradesEvent {
  const ExportTradesToPdfEvent();
}

class ExportTradesToExcelEvent extends TradesEvent {
  const ExportTradesToExcelEvent();
}

class UpdateDateRangeEvent extends TradesEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const UpdateDateRangeEvent({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}