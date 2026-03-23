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
    on<SymbolWisePLFilter>(_onSymbolWisePLFilter);
  }
  void _onSymbolWisePLFilter(
    SymbolWisePLFilter event,
    Emitter<SymbolWisePLState> emit,
  ) {
    final currentState = state;
    if (currentState is SymbolWisePLLoaded) {
      emit(
        currentState.copyWith(
          selectedExchange: event.exchange ?? currentState.selectedExchange,
          selectedSymbol: event.symbol ?? currentState.selectedSymbol,
        ),
      );
    }
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
        final exchanges = <String>[
          'NSE',
          'MCX',
          'CE/PE',
          'OTHERS',
          'COMEX FUTURE',
          'COMEX SPOT',
          'CRYPTO',
          'GIFT',
          'FOREX',
        ];
        final symbols = reports.map((e) => e.symbol).toSet().toList()..sort();
        emit(
          SymbolWisePLLoaded(
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

  Future<void> _onFilterSymbolWisePL(
    FilterSymbolWisePL event,
    Emitter<SymbolWisePLState> emit,
  ) async {
    final currentState = state;
    List<String> exchanges = [];
    List<String> symbols = [];
    String? currentExchange;
    String? currentSymbol;
    if (currentState is SymbolWisePLLoaded) {
      exchanges = currentState.exchanges;
      symbols = currentState.symbols;
      currentExchange = currentState.selectedExchange;
      currentSymbol = currentState.selectedSymbol;
    }
    emit(SymbolWisePLLoading());
    final newExchange = event.exchange ?? currentExchange;
    final newSymbol = event.symbol ?? currentSymbol;
    final result = await getSymbolWisePLReport(
      exchange: newExchange,
      symbol: newSymbol,
    );
    result.fold(
      (failure) => emit(SymbolWisePLError(message: failure.message)),
      (reports) {
        emit(
          SymbolWisePLLoaded(
            reports: reports,
            exchanges: exchanges,
            symbols: symbols,
            selectedExchange: newExchange,
            selectedSymbol: newSymbol,
          ),
        );
      },
    );
  }
}
