import 'package:bazarpro/features/market_watch/presentation/bloc/theme/theme_event.dart';
import 'package:bazarpro/features/market_watch/presentation/bloc/theme/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }
  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }
}