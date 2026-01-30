import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_trade_margin.dart';
import 'user_trade_margin_event.dart';
import 'user_trade_margin_state.dart';


class UserTradeMarginBloc
    extends Bloc<UserTradeMarginEvent, UserTradeMarginState> {
  UserTradeMarginBloc() : super(UserTradeMarginLoading()) {
    on<LoadUserTradeMargins>(_onLoadUserTradeMargins);
    on<FilterUserTradeMargins>(_onFilterUserTradeMargins);
    on<ToggleUserTradeMarginSelection>(_onToggleSelection);
    on<ToggleAllUserTradeMarginSelection>(_onToggleAllSelection);
    on<UpdateUserTradeMargin>(_onUpdateMargin);
  }

  final List<UserTradeMargin> _mockMargins = [
    UserTradeMargin(
      id: '1',
      exchange: 'MCX',
      symbol: '360NE',
      expiryDate: DateTime(2025, 12, 26, 12, 0),
      marginPercentage: 10000,
      marginAmount: 10000,
    ),
    UserTradeMargin(
      id: '2',
      exchange: 'MCX',
      symbol: 'AARTIND',
      expiryDate: DateTime(2025, 12, 26, 12, 0),
      marginPercentage: 1500,
      marginAmount: 1500,
    ),
    UserTradeMargin(
      id: '3',
      exchange: 'MCX',
      symbol: 'ABB',
      expiryDate: DateTime(2025, 12, 26, 12, 0),
      marginPercentage: 0,
      marginAmount: 0,
    ),
    UserTradeMargin(
      id: '4',
      exchange: 'MCX',
      symbol: 'ABBOTINDIA',
      expiryDate: DateTime(2025, 12, 26, 12, 0),
      marginPercentage: 0,
      marginAmount: 0,
    ),
    UserTradeMargin(
      id: '5',
      exchange: 'MCX',
      symbol: 'ABCAPITAL',
      expiryDate: DateTime(2025, 12, 26, 12, 0),
      marginPercentage: 1000,
      marginAmount: 1000,
    ),
    UserTradeMargin(
      id: '6',
      exchange: 'MCX',
      symbol: 'ACC',
      expiryDate: DateTime(2025, 12, 26, 12, 0),
      marginPercentage: 2000,
      marginAmount: 2000,
    ),
    UserTradeMargin(
      id: '7',
      exchange: 'MCX',
      symbol: 'AMBER',
      expiryDate: DateTime(2025, 12, 26, 12, 0),
      marginPercentage: 1000,
      marginAmount: 1000,
    ),
    UserTradeMargin(
      id: '8',
      exchange: 'MCX',
      symbol: 'ALKEM',
      expiryDate: DateTime(2025, 12, 26, 12, 0),
      marginPercentage: 2000,
      marginAmount: 2000,
    ),
    UserTradeMargin(
      id: '9',
      exchange: 'MCX',
      symbol: 'AMBUJACEM',
      expiryDate: DateTime(2025, 12, 26, 12, 0),
      marginPercentage: 1000,
      marginAmount: 1000,
    ),
  ];

  void _onLoadUserTradeMargins(
    LoadUserTradeMargins event,
    Emitter<UserTradeMarginState> emit,
  ) async {
    emit(UserTradeMarginLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(
      UserTradeMarginLoaded(
        allMargins: _mockMargins,
        filteredMargins: _mockMargins,
      ),
    );
  }

  void _onFilterUserTradeMargins(
    FilterUserTradeMargins event,
    Emitter<UserTradeMarginState> emit,
  ) {
    if (state is UserTradeMarginLoaded) {
      final currentState = state as UserTradeMarginLoaded;

      List<UserTradeMargin> filtered = currentState.allMargins.where((item) {
        bool matchesExchange =
            event.exchange == null || item.exchange == event.exchange;
        bool matchesSymbol =
            event.symbol == null || item.symbol == event.symbol;
        bool matchesSearch =
            event.searchQuery == null ||
            event.searchQuery!.isEmpty ||
            item.symbol.toLowerCase().contains(
              event.searchQuery!.toLowerCase(),
            );

        return matchesExchange && matchesSymbol && matchesSearch;
      }).toList();

      emit(
        currentState.copyWith(
          filteredMargins: filtered,
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
          searchQuery: event.searchQuery,
        ),
      );
    }
  }

  void _onToggleSelection(
    ToggleUserTradeMarginSelection event,
    Emitter<UserTradeMarginState> emit,
  ) {
    if (state is UserTradeMarginLoaded) {
      final currentState = state as UserTradeMarginLoaded;
      final updatedFiltered = currentState.filteredMargins.map((item) {
        if (item.id == event.id) {
          return item.copyWith(isSelected: !item.isSelected);
        }
        return item;
      }).toList();

      // Also update in allMargins
      final updatedAll = currentState.allMargins.map((item) {
        if (item.id == event.id) {
          return item.copyWith(isSelected: !item.isSelected);
        }
        return item;
      }).toList();

      final allSelected =
          updatedFiltered.isNotEmpty &&
          updatedFiltered.every((item) => item.isSelected);

      emit(
        currentState.copyWith(
          filteredMargins: updatedFiltered,
          allMargins: updatedAll,
          isAllSelected: allSelected,
        ),
      );
    }
  }

  void _onToggleAllSelection(
    ToggleAllUserTradeMarginSelection event,
    Emitter<UserTradeMarginState> emit,
  ) {
    if (state is UserTradeMarginLoaded) {
      final currentState = state as UserTradeMarginLoaded;
      final updatedFiltered = currentState.filteredMargins.map((item) {
        return item.copyWith(isSelected: event.isSelected);
      }).toList();

      // Also update matching items in allMargins
      final updatedAll = currentState.allMargins.map((item) {
        // Naive update: if exists in filteredList (by ID), update it.
        final isInFiltered = updatedFiltered.any((f) => f.id == item.id);
        if (isInFiltered) {
          return item.copyWith(isSelected: event.isSelected);
        }
        return item;
      }).toList();

      emit(
        currentState.copyWith(
          filteredMargins: updatedFiltered,
          allMargins: updatedAll,
          isAllSelected: event.isSelected,
        ),
      );
    }
  }

  void _onUpdateMargin(
    UpdateUserTradeMargin event,
    Emitter<UserTradeMarginState> emit,
  ) {
    if (state is UserTradeMarginLoaded) {
      final currentState = state as UserTradeMarginLoaded;

      final updatedAll = currentState.allMargins.map((item) {
        if (item.isSelected) {
          // Logic based on marginType. For now assuming simple update
          return item.copyWith(
            marginPercentage: event.value, // Simplified
            marginAmount: event.value, // Simplified
          );
        }
        return item;
      }).toList();

      // Re-filter
      List<UserTradeMargin> filtered = updatedAll.where((item) {
        // Re-apply current filters
        bool matchesExchange =
            currentState.selectedExchange == null ||
            item.exchange == currentState.selectedExchange;
        bool matchesSymbol =
            currentState.selectedSymbol == null ||
            item.symbol == currentState.selectedSymbol;
        bool matchesSearch =
            currentState.searchQuery == null ||
            currentState.searchQuery!.isEmpty ||
            item.symbol.toLowerCase().contains(
              currentState.searchQuery!.toLowerCase(),
            );
        return matchesExchange && matchesSymbol && matchesSearch;
      }).toList();

      emit(
        currentState.copyWith(
          allMargins: updatedAll,
          filteredMargins: filtered,
        ),
      );
    }
  }
}
