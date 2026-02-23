import 'package:bazarpro/features/report/domain/entities/trade_log.dart';
import 'package:bazarpro/features/report/domain/usecases/get_trade_logs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trade_log_event.dart';
import 'trade_log_state.dart';

class TradeLogBloc extends Bloc<TradeLogEvent, TradeLogState> {
  final GetTradeLogsUseCase getTradeLogs;
  TradeLogBloc({required this.getTradeLogs}) : super(TradeLogInitial()) {
    on<LoadTradeLogsEvent>(_onLoadTradeLogs);
    on<FilterTradeLogsEvent>(_onFilterTradeLogs);
    on<SortTradeLogsEvent>(_onSortTradeLogs);
    on<ResetTradeLogsFiltersEvent>(_onResetFilters);
  }
  Future<void> _onLoadTradeLogs(
    LoadTradeLogsEvent event,
    Emitter<TradeLogState> emit,
  ) async {
    emit(TradeLogLoading());
    final result = await getTradeLogs();
    result.fold((failure) => emit(TradeLogError(message: failure.message)), (
      tradeLogs,
    ) {
      final users = tradeLogs.map((e) => e.userName).toSet().toList();
      final exchanges = tradeLogs.map((e) => e.exchange).toSet().toList();
      final symbols = tradeLogs.map((e) => e.symbol).toSet().toList();
      emit(
        TradeLogLoaded(
          tradeLogs: tradeLogs,
          filteredTradeLogs: tradeLogs,
          users: users,
          exchanges: exchanges,
          symbols: symbols,
        ),
      );
    });
  }

  void _onFilterTradeLogs(
    FilterTradeLogsEvent event,
    Emitter<TradeLogState> emit,
  ) {
    if (state is TradeLogLoaded) {
      final currentState = state as TradeLogLoaded;
      var filtered = currentState.tradeLogs;
      if (event.user != null && event.user!.isNotEmpty) {
        filtered = filtered.where((e) => e.userName == event.user).toList();
      }
      if (event.exchange != null && event.exchange!.isNotEmpty) {
        filtered = filtered.where((e) => e.exchange == event.exchange).toList();
      }
      if (event.symbol != null && event.symbol!.isNotEmpty) {
        filtered = filtered.where((e) => e.symbol == event.symbol).toList();
      }
      emit(
        currentState.copyWith(
          filteredTradeLogs: filtered,
          selectedDateRange: event.dateRange ?? currentState.selectedDateRange,
          selectedUser: event.user ?? currentState.selectedUser,
          selectedExchange: event.exchange ?? currentState.selectedExchange,
          selectedSymbol: event.symbol ?? currentState.selectedSymbol,
        ),
      );
    }
  }

  void _onSortTradeLogs(SortTradeLogsEvent event, Emitter<TradeLogState> emit) {
    if (state is TradeLogLoaded) {
      final currentState = state as TradeLogLoaded;
      final sortedList = List<TradeLog>.from(currentState.filteredTradeLogs);
      sortedList.sort((a, b) {
        int comparison = 0;
        switch (event.columnId) {
          case 'userName':
            comparison = a.userName.compareTo(b.userName);
            break;
          case 'exchange':
            comparison = a.exchange.compareTo(b.exchange);
            break;
          case 'symbol':
            comparison = a.symbol.compareTo(b.symbol);
            break;
          case 'qty':
            comparison = a.qty.compareTo(b.qty);
            break;
          case 'price':
            comparison = a.price.compareTo(b.price);
            break;
          case 'updateTime':
            comparison = a.updateTime.compareTo(b.updateTime);
            break;
          default:
            comparison = 0;
        }
        return event.ascending ? comparison : -comparison;
      });
      emit(
        currentState.copyWith(
          filteredTradeLogs: sortedList,
          sortColumn: event.columnId,
          sortAscending: event.ascending,
        ),
      );
    }
  }

  void _onResetFilters(
    ResetTradeLogsFiltersEvent event,
    Emitter<TradeLogState> emit,
  ) {
    if (state is TradeLogLoaded) {
      final currentState = state as TradeLogLoaded;
      emit(
        currentState.copyWith(
          filteredTradeLogs: currentState.tradeLogs,
          selectedDateRange: null,
          selectedUser: null,
          selectedExchange: null,
          selectedSymbol: null,
        ),
      );
    }
  }
}
