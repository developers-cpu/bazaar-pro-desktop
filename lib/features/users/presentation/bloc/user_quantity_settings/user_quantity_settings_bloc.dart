import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_quantity_setting.dart';
import 'user_quantity_settings_event.dart';
import 'user_quantity_settings_state.dart';

class UserQuantitySettingsBloc
    extends Bloc<UserQuantitySettingsEvent, UserQuantitySettingsState> {
  UserQuantitySettingsBloc() : super(UserQuantitySettingsInitial()) {
    on<LoadUserQuantitySettings>(_onLoadUserQuantitySettings);
    on<FilterUserQuantitySettings>(_onFilterUserQuantitySettings);
    on<UpdateSelectedUserQuantitySetting>(_onUpdateSelectedUserQuantitySetting);
  }

  void _onLoadUserQuantitySettings(
    LoadUserQuantitySettings event,
    Emitter<UserQuantitySettingsState> emit,
  ) async {
    emit(UserQuantitySettingsLoading());
    try {
      await Future.delayed(const Duration(seconds: 1)); 

      final settings = _generateMockSettings();
      emit(
        UserQuantitySettingsLoaded(
          allSettings: settings,
          filteredSettings: settings,
        ),
      );
    } catch (e) {
      emit(UserQuantitySettingsError(e.toString()));
    }
  }

  void _onFilterUserQuantitySettings(
    FilterUserQuantitySettings event,
    Emitter<UserQuantitySettingsState> emit,
  ) {
    if (state is UserQuantitySettingsLoaded) {
      final currentState = state as UserQuantitySettingsLoaded;
      final symbol = event.symbol;

      List<UserQuantitySetting> filtered = currentState.allSettings;

      if (symbol != null && symbol.isNotEmpty) {
        filtered = currentState.allSettings
            .where((s) => s.symbol.toUpperCase().contains(symbol.toUpperCase()))
            .toList();
      }

      emit(
        UserQuantitySettingsLoaded(
          allSettings: currentState.allSettings,
          filteredSettings: filtered,
          selectedSymbol: symbol,
        ),
      );
    }
  }

  void _onUpdateSelectedUserQuantitySetting(
    UpdateSelectedUserQuantitySetting event,
    Emitter<UserQuantitySettingsState> emit,
  ) async {
    
    
    if (state is UserQuantitySettingsLoaded) {
      final currentState = state as UserQuantitySettingsLoaded;

      final updatedAllSettings = currentState.allSettings.map((s) {
        if (event.selectedIds.contains(s.id)) {
          return UserQuantitySetting(
            id: s.id,
            symbol: s.symbol,
            maxQty: event.maxQty ?? s.maxQty,
            breakupQty: event.breakupQty ?? s.breakupQty,
            maxLot: event.maxLot ?? s.maxLot,
            breakupLot: event.breakupLot ?? s.breakupLot,
          );
        }
        return s;
      }).toList();

      
      final symbol = currentState.selectedSymbol;
      List<UserQuantitySetting> filtered = updatedAllSettings;
      if (symbol != null && symbol.isNotEmpty) {
        filtered = updatedAllSettings
            .where((s) => s.symbol.toUpperCase().contains(symbol.toUpperCase()))
            .toList();
      }

      emit(
        UserQuantitySettingsLoaded(
          allSettings: updatedAllSettings,
          filteredSettings: filtered,
          selectedSymbol: symbol,
        ),
      );
    }
  }

  List<UserQuantitySetting> _generateMockSettings() {
    return [
      const UserQuantitySetting(
        id: '1',
        symbol: '360NE',
        maxQty: 15000,
        breakupQty: 15000,
        maxLot: 10000,
        breakupLot: 10000,
      ),
      const UserQuantitySetting(
        id: '2',
        symbol: 'AARTIND',
        maxQty: 5000,
        breakupQty: 5000,
        maxLot: 1500,
        breakupLot: 1500,
      ),
      const UserQuantitySetting(
        id: '3',
        symbol: 'ABB',
        maxQty: 0,
        breakupQty: 0,
        maxLot: 0,
        breakupLot: 0,
      ),
      const UserQuantitySetting(
        id: '4',
        symbol: 'ABBOTINDIA',
        maxQty: 0,
        breakupQty: 0,
        maxLot: 0,
        breakupLot: 0,
      ),
      const UserQuantitySetting(
        id: '5',
        symbol: 'ABCAPITAL',
        maxQty: 5000,
        breakupQty: 5000,
        maxLot: 1000,
        breakupLot: 1000,
      ),
      const UserQuantitySetting(
        id: '6',
        symbol: 'ACC',
        maxQty: 30003,
        breakupQty: 30003,
        maxLot: 2000,
        breakupLot: 2000,
      ),
      const UserQuantitySetting(
        id: '7',
        symbol: 'AMBER',
        maxQty: 3000,
        breakupQty: 3000,
        maxLot: 1000,
        breakupLot: 1000,
      ),
      const UserQuantitySetting(
        id: '8',
        symbol: 'ALKEM',
        maxQty: 2000,
        breakupQty: 2000,
        maxLot: 2000,
        breakupLot: 2000,
      ),
    ];
  }
}
