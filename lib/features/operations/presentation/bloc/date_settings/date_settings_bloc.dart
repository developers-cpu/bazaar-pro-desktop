import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/date_settings/get_date_settings.dart';
import '../../../domain/usecases/date_settings/update_date_settings.dart';
import 'date_settings_event.dart';
import 'date_settings_state.dart';
class DateSettingsBloc extends Bloc<DateSettingsEvent, DateSettingsState> {
  final GetDateSettings getDateSettings;
  final UpdateDateSettings updateDateSettings;
  DateSettingsBloc({
    required this.getDateSettings,
    required this.updateDateSettings,
  }) : super(DateSettingsInitial()) {
    on<LoadDateSettingsEvent>((event, emit) async {
      emit(DateSettingsLoading());
      final result = await getDateSettings(NoParams());
      result.fold(
        (failure) => emit(const DateSettingsError('Failed to load settings')),
        (settings) => emit(DateSettingsLoaded(settings)),
      );
    });
    on<UpdateDateSettingsEvent>((event, emit) async {
      emit(DateSettingsLoading());
      final result = await updateDateSettings(
        UpdateDateSettingsParams(ids: event.ids, details: event.details),
      );
      result.fold(
        (failure) => emit(const DateSettingsError('Failed to update')),
        (success) {
          emit(
            const DateSettingsUpdateSuccess('Settings updated successfully'),
          );
          add(LoadDateSettingsEvent());
        },
      );
    });
  }
}
