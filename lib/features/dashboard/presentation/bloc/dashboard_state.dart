import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_entity.dart';


abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final List<TradeReportData> tradeReports;
  final String? tradeReportClientId;
  final String tradeReportPeriod;
  final Set<String> tradeReportSelectedExchanges;
  final List<SymbolReportData> symbolReports;
  final String? symbolReportClientId;
  final String symbolReportPeriod;
  final Set<String> symbolReportSelectedExchanges;
  final int symbolReportTopCount;
  final DashboardSummary summary;
  final List<String> clients;
  final List<String> periods;
  final List<String> exchanges;
  final List<int> topCounts;

  const DashboardLoaded({
    required this.tradeReports,
    this.tradeReportClientId,
    this.tradeReportPeriod = 'Day',
    this.tradeReportSelectedExchanges = const {},
    required this.symbolReports,
    this.symbolReportClientId,
    this.symbolReportPeriod = 'Day',
    this.symbolReportSelectedExchanges = const {},
    this.symbolReportTopCount = 10,
    required this.summary,
    this.clients = const ['Client 1', 'Client 2', 'Client 3', 'Client 4', 'Client 5'],
    this.periods = const ['Day', 'Week', 'Month'],
    this.exchanges = const ['NSE', 'MCX', 'GIFTNIFTY', 'CE/PE', 'OTHERS', 'COMEX', 'CRYPTO', 'FOREX', 'USSTOCK'],
    this.topCounts = const [5, 10, 15],
  });

  DashboardLoaded copyWith({
    List<TradeReportData>? tradeReports,
    String? tradeReportClientId,
    String? tradeReportPeriod,
    Set<String>? tradeReportSelectedExchanges,
    List<SymbolReportData>? symbolReports,
    String? symbolReportClientId,
    String? symbolReportPeriod,
    Set<String>? symbolReportSelectedExchanges,
    int? symbolReportTopCount,
    DashboardSummary? summary,
    List<String>? clients,
    List<String>? periods,
    List<String>? exchanges,
    List<int>? topCounts,
    bool clearTradeClient = false,
    bool clearSymbolClient = false,
  }) {
    return DashboardLoaded(
      tradeReports: tradeReports ?? this.tradeReports,
      tradeReportClientId: clearTradeClient ? null : (tradeReportClientId ?? this.tradeReportClientId),
      tradeReportPeriod: tradeReportPeriod ?? this.tradeReportPeriod,
      tradeReportSelectedExchanges: tradeReportSelectedExchanges ?? this.tradeReportSelectedExchanges,
      symbolReports: symbolReports ?? this.symbolReports,
      symbolReportClientId: clearSymbolClient ? null : (symbolReportClientId ?? this.symbolReportClientId),
      symbolReportPeriod: symbolReportPeriod ?? this.symbolReportPeriod,
      symbolReportSelectedExchanges: symbolReportSelectedExchanges ?? this.symbolReportSelectedExchanges,
      symbolReportTopCount: symbolReportTopCount ?? this.symbolReportTopCount,
      summary: summary ?? this.summary,
      clients: clients ?? this.clients,
      periods: periods ?? this.periods,
      exchanges: exchanges ?? this.exchanges,
      topCounts: topCounts ?? this.topCounts,
    );
  }

  @override
  List<Object?> get props => [
    tradeReports,
    tradeReportClientId,
    tradeReportPeriod,
    tradeReportSelectedExchanges,
    symbolReports,
    symbolReportClientId,
    symbolReportPeriod,
    symbolReportSelectedExchanges,
    symbolReportTopCount,
    summary,
    clients,
    periods,
    exchanges,
    topCounts,
  ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}