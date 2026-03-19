import 'package:equatable/equatable.dart';

abstract class RejectedTradeEvent extends Equatable {
  const RejectedTradeEvent();
  @override
  List<Object?> get props => [];
}

class LoadRejectedTradesEvent extends RejectedTradeEvent {
  const LoadRejectedTradesEvent();
}

class ApplyRejectedTradeFiltersEvent extends RejectedTradeEvent {
  final String? userType;
  final String? user;
  final String? exchange;
  final String? symbol;
  const ApplyRejectedTradeFiltersEvent({
    this.userType,
    this.user,
    this.exchange,
    this.symbol,
  });
  @override
  List<Object?> get props => [userType, user, exchange, symbol];
}

class ResetRejectedTradeFiltersEvent extends RejectedTradeEvent {
  const ResetRejectedTradeFiltersEvent();
}

class SortRejectedTradesByColumnEvent extends RejectedTradeEvent {
  final String columnId;
  final bool ascending;
  const SortRejectedTradesByColumnEvent({
    required this.columnId,
    required this.ascending,
  });
  @override
  List<Object?> get props => [columnId, ascending];
}

class ExportRejectedTradesToPdfEvent extends RejectedTradeEvent {
  const ExportRejectedTradesToPdfEvent();
}

class ExportRejectedTradesToExcelEvent extends RejectedTradeEvent {
  const ExportRejectedTradesToExcelEvent();
}