import 'package:bazarpro/features/view/domain/usecases/trade_margin/get_trade_margins.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trade_margin_event.dart';
import 'trade_margin_state.dart';

class TradeMarginBloc extends Bloc<TradeMarginEvent, TradeMarginState> {
  final GetTradeMarginsUseCase getTradeMargins;
  TradeMarginBloc({required this.getTradeMargins})
    : super(TradeMarginInitial()) {
    on<LoadTradeMargins>(_onLoadTradeMargins);
    on<UpdateTradeMarginFilters>(_onUpdateTradeMarginFilters);
    on<ViewTradeMargins>(_onViewTradeMargins);
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

  Future<void> _onUpdateTradeMarginFilters(
    UpdateTradeMarginFilters event,
    Emitter<TradeMarginState> emit,
  ) async {
    final currentState = state;
    if (currentState is TradeMarginLoaded) {
      final exchange = event.exchange ?? currentState.selectedExchange;
      final search = event.search ?? currentState.searchQuery;
      emit(
        currentState.copyWith(
          selectedExchange: exchange,
          searchQuery: search,
          showDialog: false,
        ),
      );
    }
  }

  Future<void> _onViewTradeMargins(
    ViewTradeMargins event,
    Emitter<TradeMarginState> emit,
  ) async {
    final currentState = state;
    if (currentState is TradeMarginLoaded) {
      emit(TradeMarginLoading());
      final result = await getTradeMargins(
        exchange: currentState.selectedExchange,
        search: currentState.searchQuery,
      );
      result.fold(
        (failure) =>
            emit(const TradeMarginError(message: 'Failed to fetch data')),
        (data) =>
            emit(currentState.copyWith(tradeMargins: data, showDialog: true)),
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
