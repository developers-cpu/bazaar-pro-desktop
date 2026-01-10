import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/dashboard_usecases.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// Dashboard BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  // Use cases
  late final GetDashboardDataUseCase _getDashboardData;
  late final GetTradeReportsUseCase _getTradeReports;
  late final GetSymbolReportsUseCase _getSymbolReports;
  late final GetDashboardSummaryUseCase _getDashboardSummary;

  DashboardBloc({required DashboardRepository repository})
      : _repository = repository,
        super(const DashboardInitial()) {
    _getDashboardData = GetDashboardDataUseCase(repository: _repository);
    _getTradeReports = GetTradeReportsUseCase(repository: _repository);
    _getSymbolReports = GetSymbolReportsUseCase(repository: _repository);
    _getDashboardSummary = GetDashboardSummaryUseCase(repository: _repository);

    on<LoadDashboardEvent>(_onLoadDashboard);
    on<FilterTradeReportsByClientEvent>(_onFilterTradeReportsByClient);
    on<FilterTradeReportsByPeriodEvent>(_onFilterTradeReportsByPeriod);
    on<ToggleTradeReportExchangeEvent>(_onToggleTradeReportExchange);
    on<FilterSymbolReportsByClientEvent>(_onFilterSymbolReportsByClient);
    on<FilterSymbolReportsByPeriodEvent>(_onFilterSymbolReportsByPeriod);
    on<ToggleSymbolReportExchangeEvent>(_onToggleSymbolReportExchange);
    on<ChangeSymbolReportTopCountEvent>(_onChangeSymbolReportTopCount);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
      LoadDashboardEvent event,
      Emitter<DashboardState> emit,
      ) async {
    emit(const DashboardLoading());

    try {
      final dashboardData = await _getDashboardData();

      emit(DashboardLoaded(
        tradeReports: dashboardData.tradeReports,
        symbolReports: dashboardData.symbolReports,
        summary: dashboardData.summary,
        tradeReportSelectedExchanges: {'NSE', 'MCX'},
        symbolReportSelectedExchanges: {'NSE', 'MCX', 'GIFTNIFTY', 'CE/PE', 'USSTOCK'},
      ));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> _onFilterTradeReportsByClient(
      FilterTradeReportsByClientEvent event,
      Emitter<DashboardState> emit,
      ) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    try {
      final tradeReports = await _getTradeReports(
        clientId: event.clientId,
        showPeriod: currentState.tradeReportPeriod,
        exchanges: currentState.tradeReportSelectedExchanges.toList(),
      );

      emit(currentState.copyWith(
        tradeReports: tradeReports,
        tradeReportClientId: event.clientId,
        clearTradeClient: event.clientId == null || event.clientId!.isEmpty,
      ));
    } catch (e) {

    }
  }

  Future<void> _onFilterTradeReportsByPeriod(
      FilterTradeReportsByPeriodEvent event,
      Emitter<DashboardState> emit,
      ) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    try {
      final tradeReports = await _getTradeReports(
        clientId: currentState.tradeReportClientId,
        showPeriod: event.period,
        exchanges: currentState.tradeReportSelectedExchanges.toList(),
      );

      emit(currentState.copyWith(
        tradeReports: tradeReports,
        tradeReportPeriod: event.period,
      ));
    } catch (e) {
    }
  }

  void _onToggleTradeReportExchange(
      ToggleTradeReportExchangeEvent event,
      Emitter<DashboardState> emit,
      ) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    final newExchanges = Set<String>.from(currentState.tradeReportSelectedExchanges);
    if (newExchanges.contains(event.exchange)) {
      newExchanges.remove(event.exchange);
    } else {
      newExchanges.add(event.exchange);
    }

    emit(currentState.copyWith(
      tradeReportSelectedExchanges: newExchanges,
    ));
  }

  Future<void> _onFilterSymbolReportsByClient(
      FilterSymbolReportsByClientEvent event,
      Emitter<DashboardState> emit,
      ) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    try {
      final symbolReports = await _getSymbolReports(
        clientId: event.clientId,
        showPeriod: currentState.symbolReportPeriod,
        exchanges: currentState.symbolReportSelectedExchanges.toList(),
        topCount: currentState.symbolReportTopCount,
      );

      emit(currentState.copyWith(
        symbolReports: symbolReports,
        symbolReportClientId: event.clientId,
        clearSymbolClient: event.clientId == null || event.clientId!.isEmpty,
      ));
    } catch (e) {
    }
  }

  Future<void> _onFilterSymbolReportsByPeriod(
      FilterSymbolReportsByPeriodEvent event,
      Emitter<DashboardState> emit,
      ) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    try {
      final symbolReports = await _getSymbolReports(
        clientId: currentState.symbolReportClientId,
        showPeriod: event.period,
        exchanges: currentState.symbolReportSelectedExchanges.toList(),
        topCount: currentState.symbolReportTopCount,
      );

      emit(currentState.copyWith(
        symbolReports: symbolReports,
        symbolReportPeriod: event.period,
      ));
    } catch (e) {
    }
  }

  void _onToggleSymbolReportExchange(
      ToggleSymbolReportExchangeEvent event,
      Emitter<DashboardState> emit,
      ) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    final newExchanges = Set<String>.from(currentState.symbolReportSelectedExchanges);
    if (newExchanges.contains(event.exchange)) {
      newExchanges.remove(event.exchange);
    } else {
      newExchanges.add(event.exchange);
    }

    emit(currentState.copyWith(
      symbolReportSelectedExchanges: newExchanges,
    ));
  }

  Future<void> _onChangeSymbolReportTopCount(
      ChangeSymbolReportTopCountEvent event,
      Emitter<DashboardState> emit,
      ) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    try {
      final symbolReports = await _getSymbolReports(
        clientId: currentState.symbolReportClientId,
        showPeriod: currentState.symbolReportPeriod,
        exchanges: currentState.symbolReportSelectedExchanges.toList(),
        topCount: event.topCount,
      );

      emit(currentState.copyWith(
        symbolReports: symbolReports,
        symbolReportTopCount: event.topCount,
      ));
    } catch (e) {
    }
  }

  Future<void> _onRefreshDashboard(
      RefreshDashboardEvent event,
      Emitter<DashboardState> emit,
      ) async {
    add(const LoadDashboardEvent());
  }
}