import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/user_trades/get_user_trades.dart';
import '../../../domain/usecases/user_trades/get_user_trades_metadata_usecase.dart';
import '../../../domain/entities/user_trades/user_trade.dart';
import '../../../../../core/usecases/usecase.dart';
import 'user_trades_event.dart';
import 'user_trades_state.dart';

class UserTradesBloc extends Bloc<UserTradesEvent, UserTradesState> {
  final GetUserTrades getUserTrades;
  final GetUserTradesMetadata getUserTradesMetadata;
  UserTradesBloc({
    required this.getUserTrades,
    required this.getUserTradesMetadata,
  }) : super(UserTradesInitial()) {
    on<LoadUserTrades>(_onLoadUserTrades);
    on<FilterUserTrades>(_onFilterUserTrades);
  }
  void _onLoadUserTrades(
    LoadUserTrades event,
    Emitter<UserTradesState> emit,
  ) async {
    emit(UserTradesLoading());
    final tradesResult = await getUserTrades(event.userId);
    final metadataResult = await getUserTradesMetadata(NoParams());
    tradesResult.fold((failure) => emit(UserTradesError(failure.message)), (
      trades,
    ) {
      metadataResult.fold(
        (failure) => emit(
          UserTradesLoaded(
            allTrades: trades,
            filteredTrades: trades,
            metadata: null,
          ),
        ),
        (metadata) => emit(
          UserTradesLoaded(
            allTrades: trades,
            filteredTrades: trades,
            metadata: metadata,
          ),
        ),
      );
    });
  }

  void _onFilterUserTrades(
    FilterUserTrades event,
    Emitter<UserTradesState> emit,
  ) {
    if (state is UserTradesLoaded) {
      final currentState = state as UserTradesLoaded;
      DateTimeRange? dateRange =
          event.dateRange ?? currentState.selectedDateRange;
      String? exchange = event.exchange ?? currentState.selectedExchange;
      String? symbol = event.symbol ?? currentState.selectedSymbol;
      String? status = event.status ?? currentState.selectedStatus;
      List<UserTrade> filtered = currentState.allTrades.where((trade) {
        bool matchesDate = true;
        if (dateRange != null) {
          matchesDate =
              trade.orderTime.isAfter(
                dateRange.start.subtract(const Duration(seconds: 1)),
              ) &&
              trade.orderTime.isBefore(
                dateRange.end.add(const Duration(days: 1)),
              );
        }
        bool matchesExchange = true;
        if (exchange != null && exchange.isNotEmpty && exchange != 'All') {
          matchesExchange = trade.exchange == exchange;
        }
        bool matchesSymbol = true;
        if (symbol != null && symbol.isNotEmpty) {
          matchesSymbol = trade.symbol.toLowerCase().contains(
            symbol.toLowerCase(),
          );
        }
        bool matchesStatus = true;
        if (status != null && status.isNotEmpty && status != 'All') {
          if (status == 'Market' || status == 'Intraday') {
            matchesStatus = trade.tradeType == status;
          }
        }
        return matchesDate && matchesExchange && matchesSymbol && matchesStatus;
      }).toList();
      emit(
        currentState.copyWith(
          filteredTrades: filtered,
          selectedDateRange: dateRange,
          selectedExchange: exchange,
          selectedSymbol: symbol,
          selectedStatus: status,
        ),
      );
    }
  }
}
