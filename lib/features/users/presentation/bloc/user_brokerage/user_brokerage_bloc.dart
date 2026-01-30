import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_brokerage_setting.dart';
import 'user_brokerage_event.dart';
import 'user_brokerage_state.dart';


class UserBrokerageBloc extends Bloc<UserBrokerageEvent, UserBrokerageState> {
  UserBrokerageBloc() : super(UserBrokerageLoading()) {
    on<LoadUserBrokerage>(_onLoadUserBrokerage);
    on<ToggleBrokerageType>(_onToggleBrokerageType);
    on<FilterBrokerage>(_onFilterBrokerage);
    on<UpdateBrokerageSettings>(_onUpdateBrokerageSettings);
  }

  // Mock data
  List<UserBrokerageSetting> _generateMockData() {
    return [
      const UserBrokerageSetting(
        id: '1',
        exchange: 'NSE',
        turnoverWiseBrk: 15000,
        symbolWiseBrk: 15000,
        symbol: '360NE',
      ),
      const UserBrokerageSetting(
        id: '2',
        exchange: 'MCX',
        turnoverWiseBrk: 5000,
        symbolWiseBrk: 5000,
        symbol: 'AARTIND',
      ),
      const UserBrokerageSetting(
        id: '3',
        exchange: 'OTHERS',
        turnoverWiseBrk: 0,
        symbolWiseBrk: 0,
        symbol: 'ABB',
      ),
      const UserBrokerageSetting(
        id: '4',
        exchange: 'FOREX',
        turnoverWiseBrk: 0,
        symbolWiseBrk: 0,
        symbol: 'ABBOTINDIA',
      ),
      const UserBrokerageSetting(
        id: '5',
        exchange: 'USSTOCKS',
        turnoverWiseBrk: 5000,
        symbolWiseBrk: 5000,
        symbol: 'ABCAPITAL',
      ),
      const UserBrokerageSetting(
        id: '6',
        exchange: 'CRYPTO',
        turnoverWiseBrk: 30003,
        symbolWiseBrk: 30003,
        symbol: 'ACC',
      ),
      const UserBrokerageSetting(
        id: '7',
        exchange: 'MCX',
        turnoverWiseBrk: 2000,
        symbolWiseBrk: 2000,
        symbol: 'CRUDEOIL',
      ),
    ];
  }

  void _onLoadUserBrokerage(
    LoadUserBrokerage event,
    Emitter<UserBrokerageState> emit,
  ) async {
    emit(UserBrokerageLoading());
    await Future.delayed(const Duration(seconds: 1));
    final data = _generateMockData();
    emit(UserBrokerageLoaded(allSettings: data, filteredSettings: data));
  }

  void _onToggleBrokerageType(
    ToggleBrokerageType event,
    Emitter<UserBrokerageState> emit,
  ) {
    if (state is UserBrokerageLoaded) {
      final currentState = state as UserBrokerageLoaded;
      emit(
        currentState.copyWith(
          viewType: event.viewType,
          filteredSettings: _applyFilters(
            currentState.allSettings,
            event.viewType,
            currentState.selectedExchange,
            currentState.selectedSymbol,
          ),
        ),
      );
    }
  }

  void _onFilterBrokerage(
    FilterBrokerage event,
    Emitter<UserBrokerageState> emit,
  ) {
    if (state is UserBrokerageLoaded) {
      final currentState = state as UserBrokerageLoaded;
      emit(
        currentState.copyWith(
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
          filteredSettings: _applyFilters(
            currentState.allSettings,
            currentState.viewType,
            event.exchange,
            event.symbol,
          ),
        ),
      );
    }
  }

  void _onUpdateBrokerageSettings(
    UpdateBrokerageSettings event,
    Emitter<UserBrokerageState> emit,
  ) async {
    // Here we would call API to update. For now just update local state logic if needed,
    // or just re-emit success/loading.
    if (state is UserBrokerageLoaded) {
      final currentState = state as UserBrokerageLoaded;
      final updatedAll = currentState.allSettings.map((item) {
        if (event.selectedIds.contains(item.id)) {
          return item.copyWith(
            turnoverWiseBrk: event.turnoverWiseBrk,
            symbolWiseBrk: event.symbolWiseBrk,
          );
        }
        return item;
      }).toList();

      emit(
        currentState.copyWith(
          allSettings: updatedAll,
          filteredSettings: _applyFilters(
            updatedAll,
            currentState.viewType,
            currentState.selectedExchange,
            currentState.selectedSymbol,
          ),
        ),
      );
    }
  }

  List<UserBrokerageSetting> _applyFilters(
    List<UserBrokerageSetting> all,
    String viewType,
    String? exchange,
    String? symbol,
  ) {
    return all.where((item) {
      if (viewType == 'Exchange') {
        if (exchange != null && item.exchange != exchange) return false;
        return true;
      } else {
        if (exchange != null && item.exchange != exchange) return false;
        if (symbol != null &&
            !item.symbol!.toLowerCase().contains(symbol.toLowerCase()))
          return false;
        return true;
      }
    }).toList();
  }
}
