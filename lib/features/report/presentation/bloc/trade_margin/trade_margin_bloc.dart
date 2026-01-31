import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_trade_margins.dart';
import 'trade_margin_event.dart';
import 'trade_margin_state.dart';

class TradeMarginBloc extends Bloc<TradeMarginEvent, TradeMarginState> {
  final GetTradeMarginsUseCase getTradeMargins;

  TradeMarginBloc({required this.getTradeMargins})
    : super(TradeMarginInitial()) {
    on<LoadTradeMargins>(_onLoadTradeMargins);
    on<FilterTradeMargins>(_onFilterTradeMargins);
    on<ResetTradeMarginFilters>(_onResetTradeMarginFilters);
  }

  Future<void> _onLoadTradeMargins(
    LoadTradeMargins event,
    Emitter<TradeMarginState> emit,
  ) async {
    emit(TradeMarginLoading());

    final result = await getTradeMargins();

    result.fold(
      (failure) => emit(const TradeMarginError(message: 'Failed to load data')),
      (data) => emit(TradeMarginLoaded(tradeMargins: data)),
    );
  }

  Future<void> _onFilterTradeMargins(
    FilterTradeMargins event,
    Emitter<TradeMarginState> emit,
  ) async {
    final currentState = state;
    if (currentState is TradeMarginLoaded) {
      final exchange = event.exchange ?? currentState.selectedExchange;
      final search = event.search ?? currentState.searchQuery;

      final result = await getTradeMargins(exchange: exchange, search: search);

      result.fold(
        (failure) =>
            emit(const TradeMarginError(message: 'Failed to filter data')),
        (data) => emit(
          currentState.copyWith(
            tradeMargins: data,
            selectedExchange: exchange,
            searchQuery: search,
          ),
        ),
      );
    }
  }

  Future<void> _onResetTradeMarginFilters(
    ResetTradeMarginFilters event,
    Emitter<TradeMarginState> emit,
  ) async {
    emit(TradeMarginLoading());
    final result = await getTradeMargins();
    result.fold(
      (failure) => emit(const TradeMarginError(message: 'Failed to reset')),
      (data) => emit(
        TradeMarginLoaded(
          tradeMargins: data,
          selectedExchange: null,
          searchQuery: null,
        ),
      ),
    );
  }
}
