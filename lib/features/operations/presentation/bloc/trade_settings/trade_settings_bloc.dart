import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/trade_settings/get_trade_settings.dart';
import '../../../domain/usecases/trade_settings/update_trade_settings.dart';
import 'trade_settings_event.dart';
import 'trade_settings_state.dart';

class TradeSettingsBloc extends Bloc<TradeSettingsEvent, TradeSettingsState> {
  final GetTradeSettings getTradeSettings;
  final UpdateTradeSettings updateTradeSettings;
  TradeSettingsBloc({
    required this.getTradeSettings,
    required this.updateTradeSettings,
  }) : super(TradeSettingsInitial()) {
    on<LoadTradeSettingsEvent>((event, emit) async {
      emit(TradeSettingsLoading());
      final result = await getTradeSettings(NoParams());
      result.fold(
        (failure) => emit(const TradeSettingsError('Failed to load settings')),
        (settings) => emit(TradeSettingsLoaded(settings)),
      );
    });
    on<UpdateTradeSettingsEvent>((event, emit) async {
      emit(TradeSettingsLoading());
      final result = await updateTradeSettings(
        UpdateTradeSettingsParams(ids: event.ids, details: event.details),
      );
      result.fold(
        (failure) => emit(const TradeSettingsError('Failed to update')),
        (success) {
          emit(
            const TradeSettingsUpdateSuccess('Settings updated successfully'),
          );
          add(LoadTradeSettingsEvent());
        },
      );
    });
  }
}
