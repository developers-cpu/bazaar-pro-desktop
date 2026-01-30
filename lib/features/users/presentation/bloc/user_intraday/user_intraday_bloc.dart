import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_intraday_event.dart';
import 'user_intraday_state.dart';

class UserIntradayBloc extends Bloc<UserIntradayEvent, UserIntradayState> {
  UserIntradayBloc() : super(UserIntradayLoading()) {
    on<LoadUserIntradaySettings>(_onLoadSettings);
    on<ToggleIntradaySetting>(_onToggleSetting);
  }

  void _onLoadSettings(
    LoadUserIntradaySettings event,
    Emitter<UserIntradayState> emit,
  ) async {
    emit(UserIntradayLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    // Mock settings
    final settings = {
      'MCX': true,
      'NSE': true,
      'CE/PE': true,
      'OTHER': true,
      'COMEX': true,
      'FOREX': true,
      'USSTOCK': true,
      'GIFY': true,
      'CRYPTO': true,
    };

    emit(UserIntradayLoaded(settings: settings));
  }

  void _onToggleSetting(
    ToggleIntradaySetting event,
    Emitter<UserIntradayState> emit,
  ) {
    if (state is UserIntradayLoaded) {
      final currentState = state as UserIntradayLoaded;
      final newSettings = Map<String, bool>.from(currentState.settings);
      newSettings[event.key] = event.value;
      emit(currentState.copyWith(settings: newSettings));
    }
  }
}
