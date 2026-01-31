import 'package:bazarpro/features/report/domain/entities/symbol_wise_position_report.dart';
import 'package:bazarpro/features/report/domain/usecases/get_symbol_wise_position_report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'symbol_wise_position_report_event.dart';
import 'symbol_wise_position_report_state.dart';

class SymbolWisePositionReportBloc
    extends Bloc<SymbolWisePositionReportEvent, SymbolWisePositionReportState> {
  final GetSymbolWisePositionReportUseCase getSymbolWisePositionReport;
  List<SymbolWisePositionReport> _allReports = [];

  SymbolWisePositionReportBloc({required this.getSymbolWisePositionReport})
    : super(SymbolWisePositionReportInitial()) {
    on<LoadSymbolWisePositionReport>(_onLoadSymbolWisePositionReport);
    on<FilterSymbolWisePositionReport>(_onFilterSymbolWisePositionReport);
    on<ResetSymbolWisePositionReportFilters>(
      _onResetSymbolWisePositionReportFilters,
    );
  }

  Future<void> _onLoadSymbolWisePositionReport(
    LoadSymbolWisePositionReport event,
    Emitter<SymbolWisePositionReportState> emit,
  ) async {
    emit(SymbolWisePositionReportLoading());
    final result = await getSymbolWisePositionReport();
    result.fold(
      (failure) =>
          emit(SymbolWisePositionReportError(message: failure.message)),
      (reports) {
        _allReports = reports;
        final exchanges = reports.map((e) => e.exchange).toSet().toList()
          ..sort();
        List<String> getSymbols(String? exchange) {
          if (exchange == null || exchange.isEmpty) {
            return reports.map((e) => e.symbol).toSet().toList()..sort();
          }
          return reports
              .where((e) => e.exchange == exchange)
              .map((e) => e.symbol)
              .toSet()
              .toList()
            ..sort();
        }

        emit(
          SymbolWisePositionReportLoaded(
            reports: reports,
            exchanges: exchanges,
            symbols: getSymbols(null),
          ),
        );
      },
    );
  }

  Future<void> _onFilterSymbolWisePositionReport(
    FilterSymbolWisePositionReport event,
    Emitter<SymbolWisePositionReportState> emit,
  ) async {
    final currentState = state;
    if (currentState is SymbolWisePositionReportLoaded) {
      emit(SymbolWisePositionReportLoading());
      final result = await getSymbolWisePositionReport(
        exchange: event.exchange,
        symbol: event.symbol,
      );

      result.fold(
        (failure) =>
            emit(SymbolWisePositionReportError(message: failure.message)),
        (filteredReports) {
          final exchanges = _allReports.map((e) => e.exchange).toSet().toList()
            ..sort();

          List<String> symbols;
          if (event.exchange != null && event.exchange!.isNotEmpty) {
            symbols =
                _allReports
                    .where((e) => e.exchange == event.exchange)
                    .map((e) => e.symbol)
                    .toSet()
                    .toList()
                  ..sort();
          } else {
            symbols = _allReports.map((e) => e.symbol).toSet().toList()..sort();
          }

          emit(
            SymbolWisePositionReportLoaded(
              reports: filteredReports,
              exchanges: exchanges,
              symbols: symbols,
              selectedExchange: event.exchange ?? currentState.selectedExchange,
              selectedSymbol: event.symbol ?? currentState.selectedSymbol,
            ),
          );
        },
      );
    }
  }

  Future<void> _onResetSymbolWisePositionReportFilters(
    ResetSymbolWisePositionReportFilters event,
    Emitter<SymbolWisePositionReportState> emit,
  ) async {
    emit(SymbolWisePositionReportLoading());

    final result = await getSymbolWisePositionReport();
    result.fold(
      (failure) =>
          emit(SymbolWisePositionReportError(message: failure.message)),
      (reports) {
        final exchanges = reports.map((e) => e.exchange).toSet().toList()
          ..sort();
        final symbols = reports.map((e) => e.symbol).toSet().toList()..sort();

        emit(
          SymbolWisePositionReportLoaded(
            reports: reports,
            exchanges: exchanges,
            symbols: symbols,
            selectedExchange: null,
            selectedSymbol: null,
          ),
        );
      },
    );
  }
}
