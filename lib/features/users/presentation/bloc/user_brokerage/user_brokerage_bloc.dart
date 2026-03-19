import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/user_brokerage_setting/get_user_brokerage_settings.dart';
import '../../../domain/usecases/user_brokerage_setting/update_brokerage_settings.dart'
    as usecase;
import '../../../domain/usecases/user/get_exchanges.dart' as user_exchanges;
import '../../../domain/usecases/user/get_symbols.dart' as user_symbols;
import '../../../domain/entities/user_brokerage_setting/user_brokerage_setting.dart';
import 'user_brokerage_event.dart';
import 'user_brokerage_state.dart';

class UserBrokerageBloc extends Bloc<UserBrokerageEvent, UserBrokerageState> {
  final GetUserBrokerageSettings getUserBrokerageSettings;
  final usecase.UpdateBrokerageSettings updateBrokerageSettings;
  final user_exchanges.GetExchanges getExchanges;
  final user_symbols.GetSymbols getSymbols;
  UserBrokerageBloc({
    required this.getUserBrokerageSettings,
    required this.updateBrokerageSettings,
    required this.getExchanges,
    required this.getSymbols,
  }) : super(UserBrokerageLoading()) {
    on<LoadUserBrokerage>(_onLoadUserBrokerage);
    on<ToggleBrokerageType>(_onToggleBrokerageType);
    on<FilterBrokerage>(_onFilterBrokerage);
    on<UpdateBrokerageSettings>(_onUpdateBrokerageSettings);
  }
  void _onLoadUserBrokerage(
    LoadUserBrokerage event,
    Emitter<UserBrokerageState> emit,
  ) async {
    emit(UserBrokerageLoading());
    final settingsFuture = getUserBrokerageSettings(event.userId);
    final exchangesFuture = getExchanges();
    final symbolsFuture = getSymbols();
    List<UserBrokerageSetting> settings = [];
    List<String> exchangeList = [];
    List<String> symbolList = [];
    final results = await Future.wait([
      settingsFuture,
      exchangesFuture,
      symbolsFuture,
    ]);
    results[0].fold(
      (l) => emit(UserBrokerageError(l.message)),
      (r) => settings = r as List<UserBrokerageSetting>,
    );
    if (state is UserBrokerageError) return;
    results[1].fold((l) {}, (r) => exchangeList = r as List<String>);
    results[2].fold((l) {}, (r) => symbolList = r as List<String>);
    emit(
      UserBrokerageLoaded(
        allSettings: settings,
        filteredSettings: settings,
        exchanges: exchangeList,
        symbols: symbolList,
      ),
    );
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
    if (state is UserBrokerageLoaded) {
      final currentState = state as UserBrokerageLoaded;
      final result = await updateBrokerageSettings(
        selectedIds: event.selectedIds,
        turnoverWiseBrk: event.turnoverWiseBrk,
        symbolWiseBrk: event.symbolWiseBrk,
      );
      result.fold((failure) => emit(UserBrokerageError(failure.message)), (_) {
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
      });
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