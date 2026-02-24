import 'package:bazarpro/features/report/domain/usecases/symbol_wise_pl/get_symbol_wise_pl_report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'symbol_wise_pl_event.dart';
import 'symbol_wise_pl_state.dart';

class SymbolWisePLBloc extends Bloc<SymbolWisePLEvent, SymbolWisePLState> {
  final GetSymbolWisePLReport getSymbolWisePLReport;
  SymbolWisePLBloc({required this.getSymbolWisePLReport})
    : super(SymbolWisePLInitial()) {
    on<LoadSymbolWisePL>(_onLoadSymbolWisePL);
    on<FilterSymbolWisePL>(_onFilterSymbolWisePL);
  }
  Future<void> _onLoadSymbolWisePL(
    LoadSymbolWisePL event,
    Emitter<SymbolWisePLState> emit,
  ) async {
    emit(SymbolWisePLLoading());
    final result = await getSymbolWisePLReport();
    result.fold(
      (failure) => emit(SymbolWisePLError(message: failure.message)),
      (reports) {
        final exchanges = reports.map((e) => e.exchange).toSet().toList()
          ..sort();
        final symbols = reports.map((e) => e.symbol).toSet().toList()..sort();
        emit(
          SymbolWisePLLoaded(
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

  Future<void> _onFilterSymbolWisePL(
    FilterSymbolWisePL event,
    Emitter<SymbolWisePLState> emit,
  ) async {
    emit(SymbolWisePLLoading());
    final result = await getSymbolWisePLReport(
      exchange: event.exchange == 'All' ? null : event.exchange,
      symbol: event.symbol == 'All' ? null : event.symbol,
    );
    result.fold(
      (failure) => emit(SymbolWisePLError(message: failure.message)),
      (reports) {
        final currentState = state;
        List<String> exchanges = [];
        List<String> symbols = [];
        if (currentState is SymbolWisePLLoaded) {
          exchanges = currentState.exchanges;
          symbols = currentState.symbols;
        }
        emit(
          SymbolWisePLLoaded(
            reports: reports,
            exchanges: exchanges,
            symbols: symbols,
            selectedExchange:
                event.exchange ??
                (currentState is SymbolWisePLLoaded
                    ? currentState.selectedExchange
                    : null),
            selectedSymbol:
                event.symbol ??
                (currentState is SymbolWisePLLoaded
                    ? currentState.selectedSymbol
                    : null),
          ),
        );
      },
    );
  }
}
