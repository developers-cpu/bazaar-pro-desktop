import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/symbol_wise_pl/symbol_wise_pl_repository.dart';
import 'symbol_trade_list_event.dart';
import 'symbol_trade_list_state.dart';
class SymbolTradeListBloc
    extends Bloc<SymbolTradeListEvent, SymbolTradeListState> {
  final SymbolWisePLRepository repository;
  SymbolTradeListBloc({required this.repository})
    : super(SymbolTradeListInitial()) {
    on<LoadSymbolTradeList>(_onLoadSymbolTradeList);
    on<FilterSymbolTradeList>(_onFilterSymbolTradeList);
    on<ResetSymbolTradeListFilters>(_onResetSymbolTradeListFilters);
  }
  Future<void> _onLoadSymbolTradeList(
    LoadSymbolTradeList event,
    Emitter<SymbolTradeListState> emit,
  ) async {
    emit(SymbolTradeListLoading());
    final result = await repository.getSymbolTradeLog(
      symbol: event.symbol,
      exchange: event.exchange,
      user: event.user,
      type: event.type,
      dateRange: event.dateRange,
    );
    result.fold((failure) => emit(SymbolTradeListError(failure.message)), (
      tradeLogs,
    ) {
      final users = tradeLogs.map((e) => e.userName).toSet().toList();
      final exchanges = tradeLogs.map((e) => e.exchange).toSet().toList();
      final symbols = tradeLogs.map((e) => e.symbol).toSet().toList();
      final types = tradeLogs.map((e) => e.tradeType).toSet().toList();
      emit(
        SymbolTradeListLoaded(
          tradeLogs: tradeLogs,
          selectedDateRange: event.dateRange,
          selectedUser: event.user,
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
          selectedType: event.type,
          users: users,
          exchanges: exchanges,
          symbols: symbols,
          types: types,
        ),
      );
    });
  }
  Future<void> _onFilterSymbolTradeList(
    FilterSymbolTradeList event,
    Emitter<SymbolTradeListState> emit,
  ) async {
    final currentState = state;
    if (currentState is SymbolTradeListLoaded) {
      emit(SymbolTradeListLoading());
      final result = await repository.getSymbolTradeLog(
        symbol: event.symbol ?? currentState.selectedSymbol,
        exchange: event.exchange ?? currentState.selectedExchange,
        user: event.user ?? currentState.selectedUser,
        type: event.type ?? currentState.selectedType,
        dateRange: event.dateRange ?? currentState.selectedDateRange,
      );
      result.fold((failure) => emit(SymbolTradeListError(failure.message)), (
        tradeLogs,
      ) {
        emit(
          currentState.copyWith(
            tradeLogs: tradeLogs,
            selectedDateRange:
                event.dateRange ?? currentState.selectedDateRange,
            selectedUser: event.user ?? currentState.selectedUser,
            selectedExchange: event.exchange ?? currentState.selectedExchange,
            selectedSymbol: event.symbol ?? currentState.selectedSymbol,
            selectedType: event.type ?? currentState.selectedType,
          ),
        );
      });
    } else {
      add(
        LoadSymbolTradeList(
          symbol: event.symbol,
          exchange: event.exchange,
          user: event.user,
          type: event.type,
          dateRange: event.dateRange,
        ),
      );
    }
  }
  Future<void> _onResetSymbolTradeListFilters(
    ResetSymbolTradeListFilters event,
    Emitter<SymbolTradeListState> emit,
  ) async {
    add(const LoadSymbolTradeList());
  }
}
