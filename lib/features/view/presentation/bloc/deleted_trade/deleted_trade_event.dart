import 'package:equatable/equatable.dart';
abstract class DeletedTradeEvent extends Equatable {
  const DeletedTradeEvent();
  @override
  List<Object?> get props => [];
}
class LoadDeletedTradesEvent extends DeletedTradeEvent {
  const LoadDeletedTradesEvent();
}
class ApplyDeletedTradeFiltersEvent extends DeletedTradeEvent {
  final String? userType;
  final String? user;
  final String? exchange;
  final String? symbol;
  const ApplyDeletedTradeFiltersEvent({
    this.userType,
    this.user,
    this.exchange,
    this.symbol,
  });
  @override
  List<Object?> get props => [userType, user, exchange, symbol];
}
class ResetDeletedTradeFiltersEvent extends DeletedTradeEvent {
  const ResetDeletedTradeFiltersEvent();
}
class SortDeletedTradesByColumnEvent extends DeletedTradeEvent {
  final String columnId;
  final bool ascending;
  const SortDeletedTradesByColumnEvent({
    required this.columnId,
    required this.ascending,
  });
  @override
  List<Object?> get props => [columnId, ascending];
}
class ExportDeletedTradesToPdfEvent extends DeletedTradeEvent {
  const ExportDeletedTradesToPdfEvent();
}
class ExportDeletedTradesToExcelEvent extends DeletedTradeEvent {
  const ExportDeletedTradesToExcelEvent();
}
