import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_trade.dart';
import 'user_trades_event.dart';
import 'user_trades_state.dart';

class UserTradesBloc extends Bloc<UserTradesEvent, UserTradesState> {
  UserTradesBloc() : super(UserTradesInitial()) {
    on<LoadUserTrades>(_onLoadUserTrades);
    on<FilterUserTrades>(_onFilterUserTrades);
  }

  void _onLoadUserTrades(
    LoadUserTrades event,
    Emitter<UserTradesState> emit,
  ) async {
    emit(UserTradesLoading());
    try {
      // TOD: Replace with API call
      await Future.delayed(const Duration(seconds: 1)); 

      final trades = _generateMockTrades();
      emit(UserTradesLoaded(allTrades: trades, filteredTrades: trades));
    } catch (e) {
      emit(UserTradesError(e.toString()));
    }
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
      dateRange = event.dateRange; 
      exchange = event.exchange; 
      symbol = event.symbol; 
      status = event.status;


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
          } else {
 
          }
        }

        return matchesDate && matchesExchange && matchesSymbol && matchesStatus;
      }).toList();

      emit(
        UserTradesLoaded(
          allTrades: currentState.allTrades,
          filteredTrades: filtered,
          selectedDateRange: dateRange,
          selectedExchange: exchange,
          selectedSymbol: symbol,
          selectedStatus: status,
        ),
      );
    }
  }

  List<UserTrade> _generateMockTrades() {
    return List.generate(
      20,
      (index) => UserTrade(
        id: 'trade_$index',
        userName: 'PATIL',
        parentUser: 'DEMO',
        exchange: index % 2 == 0 ? 'MCX' : 'NSE',
        symbol: index % 2 == 0 ? 'GOLD05DEC' : 'NIFTY Oct 28',
        buySell: index % 3 == 0 ? 'BUY' : 'SELL',
        tradeType: 'Market',
        quantity: index % 3 == 0 ? 100.0 : -500.0,
        lot: 1.0,
        profitLoss: index % 2 == 0 ? 36200.00 : -500.00,
        validity: 'Market',
        tradePrice: 124191.00,
        brokerage: 0.00,
        netPrice: 124191.00,
        orderTime: DateTime.now().subtract(Duration(hours: index)),
        executionTime: DateTime.now().subtract(Duration(hours: index)),
        requestPrice: 0.00,
        orderDuration: '11 hours 47 minutes',
      ),
    );
  }
}
