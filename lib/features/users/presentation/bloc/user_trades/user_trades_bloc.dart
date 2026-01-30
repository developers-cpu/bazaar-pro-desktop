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
      await Future.delayed(const Duration(seconds: 1)); // Simulate API delay

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

      // Update filters only if provided (allow null to clear? No, user logic:
      // if passing null, it might mean 'unchanged' or 'cleared'.
      // UserPositionBloc used specific logic. Let's assume passed values update the filter state.)
      // Actually, looking at FilterUserPositions, it reset if valid was passed?
      // Let's assume we pass the NEW state of filters.

      // However, usually UI maintains state or Bloc maintains state.
      // Here, let's say we update the existing filters with new values if provided.
      // OR, simpler: The UI passes the desired filter state.

      // For "Reset", we'd pass nulls.
      // For specific update, we'd pass the new value and keep others?
      // The Bloc logic below will filter based on event params.
      // If event param is null, should we keep previous or clear?
      // In UserPositionBloc, I treated event params as the *new* filter state.
      // So if I pass exchange: 'NSE', it filters by NSE. If I pass exchange: null, it clears exchange filter.
      // But we need to support "retain previous filter if not specified"?
      // No, the event contains all filters usually, or we merge.
      // Let's merge with current state if the event fields are intended as updates.
      // But typically, a filter event from UI might send all current filter values.
      // Let's implement: merge event values with current state values, unless explicit "clear".
      // Actually, simpler: The event carries the NEW values for the filters that changed.
      // But wait, if I change Exchange, I probably want to keep DateRange?
      // Let's assume the UI sends the *changed* value, and we need to keep the others from `currentState`.

      DateTimeRange? dateRange =
          event.dateRange ?? currentState.selectedDateRange;
      String? exchange = event.exchange ?? currentState.selectedExchange;
      String? symbol = event.symbol ?? currentState.selectedSymbol;
      String? status = event.status ?? currentState.selectedStatus;

      // Special case: if we want to clear, we might need a specific flag or pass a "Clear" object.
      // For now, let's assume if the UI wants to clear, it passes null, but `?? currentState` prevents clearing.
      // Issue: How to clear?
      // Solution: The UI should maintain the state of filters? No, Bloc does.
      // Let's assume the event passes *All* active filters.
      // So if UI changes exchange, it sends: Filter(exchange: newEx, symbol: oldSym, ...).
      // But that puts burden on UI to read state.
      // Alternative: `FilterUserTrades` has `reset` flag?
      // Let's look at `UserPositionBloc` logic (implied from code I wrote/viewed or standard practice).
      // Standard: CopyWith-like behavior is best if UI sends only updates.
      // BUT if I want to "unselect" exchange, I can't pass null if null means "ignore".
      // Let's assume:
      // If the User clicks "Reset", we send a specific event or `FilterUserTrades(exchange: null, symbol: null, ...)`
      // AND we treat null as "no filter" IF we don't do `?? currentState`.
      // BUT if I just change Exchange, I don't want to lose Symbol filter?
      // Let's try to match existing logic.

      // In UserPositionBloc from previous turn:
      // context.read<UserPositionBloc>().add(FilterUserPositions(exchange: val, symbol: selectedSymbol));
      // So the UI *IS* reading the current state (selectedSymbol) and passing it back!
      // Great, so I can trust the event to contain the *complete* desired filter state (or at least the UI tries to).
      // So I will use the event values directly.

      // Wait, in the code snippet I wrote for UserPositionTab:
      // onChanged: (val) { context.read<UserPositionBloc>().add(FilterUserPositions(exchange: val, symbol: selectedSymbol)); }
      // Yes, UI passes both.
      // So I can treat event fields as the definitive target state.

      dateRange = event.dateRange; // Treat as new state
      exchange = event.exchange; // Treat as new state
      symbol = event.symbol; // Treat as new state
      status = event.status; // Treat as new state

      // But wait, if I have 4 filters, does UI pass all 4 every time?
      // UserPositionTab passed both `exchange` and `symbol` because they were the only 2.
      // Here we have 4.
      // The UI code I will write for UserTradesTab should pass all 4.
      // I will implement UserTradesTab to read current state and pass all 4 values in `FilterUserTrades`.

      List<UserTrade> filtered = currentState.allTrades.where((trade) {
        bool matchesDate = true;
        if (dateRange != null) {
          // Check if orderTime is within range
          // Normalize dates to remove time if needed, or just compare
          matchesDate =
              trade.orderTime.isAfter(
                dateRange.start.subtract(const Duration(seconds: 1)),
              ) &&
              trade.orderTime.isBefore(
                dateRange.end.add(const Duration(days: 1)),
              );
          // Adding duration to include the end date fully?
          // DateTimeRange end is usually exact.
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
          // Assuming 'status' maps to specific field?
          // Screenshot shows 'Status' dropdown with: All, Market, Intraday, Settled, Pending to Success, Super Admin.
          // These look like mix of TradeType, Validity, or specific status/remarks field?
          // The table has "Validity", "Trade Type".
          // "Pending to Success" sounds like a remark.
          // Let's assume Status filters on 'Validity' or 'TradeType' or just 'Status' if we had one.
          // 'Market', 'Intraday' are TradeTypes?
          // 'Settled'??
          // Let's filter on 'tradeType' for now if it matches, or 'validity'.
          // Let's assume we check multiple or specific based on value.
          if (status == 'Market' || status == 'Intraday') {
            matchesStatus = trade.tradeType == status;
          } else {
            // Fallback or specific logic
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
