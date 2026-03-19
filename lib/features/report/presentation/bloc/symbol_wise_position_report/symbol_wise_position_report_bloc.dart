import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_symbol_wise_position_report.dart';
import 'symbol_wise_position_report_event.dart';
import 'symbol_wise_position_report_state.dart';

class SymbolWisePositionReportBloc
    extends Bloc<SymbolWisePositionReportEvent, SymbolWisePositionReportState> {
  final GetSymbolWisePositionReportUseCase getSymbolWisePositionReport;
  SymbolWisePositionReportBloc({required this.getSymbolWisePositionReport})
    : super(SymbolWisePositionReportInitial()) {
    on<LoadSymbolWisePositionReport>(_onLoad);
    on<FilterSymbolWisePositionReport>(_onFilter);
    on<ResetSymbolWisePositionReportFilters>(_onReset);
  }
  Future<void> _onLoad(
    LoadSymbolWisePositionReport event,
    Emitter<SymbolWisePositionReportState> emit,
  ) async {
    emit(SymbolWisePositionReportLoading());
    final result = await getSymbolWisePositionReport();
    result.fold(
      (failure) => emit(SymbolWisePositionReportError(failure.message)),
      (reports) {
        final exchanges = reports.map((e) => e.exchange).toSet().toList()
          ..sort();
        final symbols = reports.map((e) => e.symbol).toSet().toList()..sort();
        emit(
          SymbolWisePositionReportLoaded(
            reports: reports,
            exchanges: ['All', ...exchanges],
            symbols: ['All', ...symbols],
            selectedExchange: 'All',
            selectedSymbol: 'All',
          ),
        );
      },
    );
  }

  Future<void> _onFilter(
    FilterSymbolWisePositionReport event,
    Emitter<SymbolWisePositionReportState> emit,
  ) async {
    final currentState = state;
    if (currentState is SymbolWisePositionReportLoaded) {
      final exchange = event.exchange ?? currentState.selectedExchange;
      final symbol = event.symbol ?? currentState.selectedSymbol;
      emit(SymbolWisePositionReportLoading());
      final result = await getSymbolWisePositionReport(
        exchange: exchange == 'All' ? null : exchange,
        symbol: symbol == 'All' ? null : symbol,
      );
      result.fold(
        (failure) => emit(SymbolWisePositionReportError(failure.message)),
        (reports) {
          emit(
            currentState.copyWith(
              reports: reports,
              selectedExchange: exchange,
              selectedSymbol: symbol,
            ),
          );
        },
      );
    }
  }

  Future<void> _onReset(
    ResetSymbolWisePositionReportFilters event,
    Emitter<SymbolWisePositionReportState> emit,
  ) async {
    add(const LoadSymbolWisePositionReport());
  }
}