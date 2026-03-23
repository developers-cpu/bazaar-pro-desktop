import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadDashboardEvent extends DashboardEvent {
  const LoadDashboardEvent();
}

class FilterTradeReportsByClientEvent extends DashboardEvent {
  final String? clientId;
  const FilterTradeReportsByClientEvent({this.clientId});
  @override
  List<Object?> get props => [clientId];
}

class FilterTradeReportsByPeriodEvent extends DashboardEvent {
  final String period;
  const FilterTradeReportsByPeriodEvent({required this.period});
  @override
  List<Object?> get props => [period];
}

class ToggleTradeReportExchangeEvent extends DashboardEvent {
  final String exchange;
  const ToggleTradeReportExchangeEvent({required this.exchange});
  @override
  List<Object?> get props => [exchange];
}

class FilterSymbolReportsByClientEvent extends DashboardEvent {
  final String? clientId;
  const FilterSymbolReportsByClientEvent({this.clientId});
  @override
  List<Object?> get props => [clientId];
}

class FilterSymbolReportsByPeriodEvent extends DashboardEvent {
  final String period;
  const FilterSymbolReportsByPeriodEvent({required this.period});
  @override
  List<Object?> get props => [period];
}

class ToggleSymbolReportExchangeEvent extends DashboardEvent {
  final String exchange;
  const ToggleSymbolReportExchangeEvent({required this.exchange});
  @override
  List<Object?> get props => [exchange];
}

class ChangeSymbolReportTopCountEvent extends DashboardEvent {
  final int topCount;
  const ChangeSymbolReportTopCountEvent({required this.topCount});
  @override
  List<Object?> get props => [topCount];
}

class RefreshDashboardEvent extends DashboardEvent {
  const RefreshDashboardEvent();
}

class FilterWeeklyProgressByClientEvent extends DashboardEvent {
  final String? clientId;
  const FilterWeeklyProgressByClientEvent({this.clientId});
  @override
  List<Object?> get props => [clientId];
}

class FilterWeeklyProgressByPeriodEvent extends DashboardEvent {
  final String period;
  const FilterWeeklyProgressByPeriodEvent({required this.period});
  @override
  List<Object?> get props => [period];
}

class ToggleWeeklyProgressExchangeEvent extends DashboardEvent {
  final String exchange;
  const ToggleWeeklyProgressExchangeEvent({required this.exchange});
  @override
  List<Object?> get props => [exchange];
}
