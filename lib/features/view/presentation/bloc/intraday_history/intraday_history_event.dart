import 'package:equatable/equatable.dart';

abstract class IntradayHistoryEvent extends Equatable {
  const IntradayHistoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadIntradayHistoryEvent extends IntradayHistoryEvent {
  const LoadIntradayHistoryEvent();
}

class ApplyIntradayFiltersEvent extends IntradayHistoryEvent {
  final DateTime? date;
  final String? exchange;
  final String? symbol;
  final String? timing;
  const ApplyIntradayFiltersEvent({
    this.date,
    this.exchange,
    this.symbol,
    this.timing,
  });
  @override
  List<Object?> get props => [date, exchange, symbol, timing];
}

class UpdateIntradayFiltersEvent extends IntradayHistoryEvent {
  final DateTime? date;
  final String? exchange;
  final String? symbol;
  final String? timing;
  const UpdateIntradayFiltersEvent({
    this.date,
    this.exchange,
    this.symbol,
    this.timing,
  });
  @override
  List<Object?> get props => [date, exchange, symbol, timing];
}

class ResetIntradayFiltersEvent extends IntradayHistoryEvent {
  const ResetIntradayFiltersEvent();
}

class NavigateToSecondsViewEvent extends IntradayHistoryEvent {
  final DateTime date;
  final String exchange;
  final String symbol;
  final DateTime startTime;
  final DateTime endTime;
  const NavigateToSecondsViewEvent({
    required this.date,
    required this.exchange,
    required this.symbol,
    required this.startTime,
    required this.endTime,
  });
  @override
  List<Object?> get props => [date, exchange, symbol, startTime, endTime];
}

class LoadSecondsDataEvent extends IntradayHistoryEvent {
  final DateTime date;
  final String exchange;
  final String symbol;
  final DateTime startTime;
  final DateTime endTime;
  const LoadSecondsDataEvent({
    required this.date,
    required this.exchange,
    required this.symbol,
    required this.startTime,
    required this.endTime,
  });
  @override
  List<Object?> get props => [date, exchange, symbol, startTime, endTime];
}

class BackToListViewEvent extends IntradayHistoryEvent {
  const BackToListViewEvent();
}

class SortIntradayByColumnEvent extends IntradayHistoryEvent {
  final String columnId;
  final bool ascending;
  const SortIntradayByColumnEvent({
    required this.columnId,
    required this.ascending,
  });
  @override
  List<Object?> get props => [columnId, ascending];
}

class ExportIntradayToPdfEvent extends IntradayHistoryEvent {
  const ExportIntradayToPdfEvent();
}

class ExportIntradayToExcelEvent extends IntradayHistoryEvent {
  const ExportIntradayToExcelEvent();
}