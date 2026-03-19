import 'package:bazarpro/features/users/domain/entities/user_quantity_setting/user_quantity_setting.dart';
import 'package:bazarpro/features/users/domain/usecases/user_quantity_setting/get_user_quantity_settings_usecase.dart';
import 'package:bazarpro/features/users/domain/usecases/user_quantity_setting/get_user_quantity_settings_metadata_usecase.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_quantity_settings_event.dart';
import 'user_quantity_settings_state.dart';

class UserQuantitySettingsBloc
    extends Bloc<UserQuantitySettingsEvent, UserQuantitySettingsState> {
  final GetUserQuantitySettings getUserQuantitySettings;
  final GetUserQuantitySettingsMetadata getUserQuantitySettingsMetadata;
  UserQuantitySettingsBloc({
    required this.getUserQuantitySettings,
    required this.getUserQuantitySettingsMetadata,
  }) : super(UserQuantitySettingsInitial()) {
    on<LoadUserQuantitySettings>(_onLoadSettings);
    on<FilterUserQuantitySettings>(_onFilterSettings);
  }
  void _onLoadSettings(
    LoadUserQuantitySettings event,
    Emitter<UserQuantitySettingsState> emit,
  ) async {
    emit(UserQuantitySettingsLoading());
    final settingsResult = await getUserQuantitySettings(event.userId);
    final metadataResult = await getUserQuantitySettingsMetadata(NoParams());
    settingsResult.fold(
      (failure) => emit(UserQuantitySettingsError(failure.message)),
      (settings) {
        metadataResult.fold(
          (metaFailure) => emit(
            UserQuantitySettingsLoaded(
              settings: settings,
              filteredSettings: settings,
              metadata: null,
            ),
          ),
          (metadata) => emit(
            UserQuantitySettingsLoaded(
              settings: settings,
              filteredSettings: settings,
              metadata: metadata,
            ),
          ),
        );
      },
    );
  }

  void _onFilterSettings(
    FilterUserQuantitySettings event,
    Emitter<UserQuantitySettingsState> emit,
  ) {
    if (state is UserQuantitySettingsLoaded) {
      final currentState = state as UserQuantitySettingsLoaded;
      List<UserQuantitySetting> filtered = currentState.settings;
      if (event.symbol != null && event.symbol!.isNotEmpty) {
        filtered = filtered
            .where(
              (s) =>
                  s.symbol.toLowerCase().contains(event.symbol!.toLowerCase()),
            )
            .toList();
      }
      emit(
        currentState.copyWith(
          filteredSettings: filtered,
          selectedSymbol: event.symbol,
        ),
      );
    }
  }
}