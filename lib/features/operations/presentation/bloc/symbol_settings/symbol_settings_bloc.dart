import 'package:flutter_bloc/flutter_bloc.dart';
import 'symbol_settings_event.dart';
import 'symbol_settings_state.dart';
import '../../../data/datasources/symbol_settings_datasource.dart';

class SymbolSettingsBloc
    extends Bloc<SymbolSettingsEvent, SymbolSettingsState> {
  final SymbolSettingsDatasource datasource;

  SymbolSettingsBloc({required this.datasource})
      : super(SymbolSettingsInitial()) {
    on<LoadSymbolSettingsEvent>(_onLoad);
    on<UpdateSymbolSettingEvent>(_onUpdate);
    on<UpdateSymbolTradeMarginEvent>(_onUpdateTradeMargin);
  }

  void _onLoad(
    LoadSymbolSettingsEvent event,
    Emitter<SymbolSettingsState> emit,
  ) {
    emit(SymbolSettingsLoading());
    try {
      final settings = datasource.getSymbolSettings(exchange: event.exchange);
      emit(
        SymbolSettingsLoaded(
          settings: settings,
          currentExchange: event.exchange,
        ),
      );
    } catch (e) {
      emit(SymbolSettingsError('Failed to load symbol settings: $e'));
    }
  }

  void _onUpdate(
    UpdateSymbolSettingEvent event,
    Emitter<SymbolSettingsState> emit,
  ) {
    if (state is SymbolSettingsLoaded) {
      final current = state as SymbolSettingsLoaded;
      final updated = current.settings.map((s) {
        if (s.id == event.id) return event.updated;
        return s;
      }).toList();
      emit(
        SymbolSettingsLoaded(
          settings: updated,
          currentExchange: current.currentExchange,
        ),
      );
    }
  }

  void _onUpdateTradeMargin(
    UpdateSymbolTradeMarginEvent event,
    Emitter<SymbolSettingsState> emit,
  ) {
    if (state is SymbolSettingsLoaded) {
      final current = state as SymbolSettingsLoaded;
      final updated = current.settings.map((s) {
        if (s.id == event.id) {
          return s.copyWith(
            marginType: event.marginType,
            intradayMarginPercent: event.intradayMarginPercent,
            carryForwardMarginPercent: event.carryForwardMarginPercent,
            intradayMarginAmount: event.intradayMarginAmount,
            carryForwardMarginAmount: event.carryForwardMarginAmount,
          );
        }
        return s;
      }).toList();
      emit(
        SymbolSettingsLoaded(
          settings: updated,
          currentExchange: current.currentExchange,
        ),
      );
    }
  }
}
