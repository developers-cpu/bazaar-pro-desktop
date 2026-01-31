import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/user_intraday_square_off/get_user_intraday_square_off_usecase.dart';
import 'user_intraday_event.dart';
import 'user_intraday_state.dart';

class UserIntradayBloc extends Bloc<UserIntradayEvent, UserIntradayState> {
  final GetUserIntradaySquareOff getUserIntradaySquareOff;

  UserIntradayBloc({required this.getUserIntradaySquareOff})
    : super(UserIntradayLoading()) {
    on<LoadUserIntradaySettings>(_onLoadSettings);
    on<ToggleIntradaySetting>(_onToggleSetting);
  }

  void _onLoadSettings(
    LoadUserIntradaySettings event,
    Emitter<UserIntradayState> emit,
  ) async {
    emit(UserIntradayLoading());
    final result = await getUserIntradaySquareOff(event.userId);
    result.fold(
      (failure) => emit(UserIntradayError(failure.message)),
      (settings) => emit(UserIntradayLoaded(settings: settings)),
    );
  }

  void _onToggleSetting(
    ToggleIntradaySetting event,
    Emitter<UserIntradayState> emit,
  ) {
    if (state is UserIntradayLoaded) {
      final currentState = state as UserIntradayLoaded;
    }
  }
}
