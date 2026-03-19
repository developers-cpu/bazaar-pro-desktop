import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/script_settings/script_setting.dart';
import '../../../domain/usecases/script_settings/get_script_settings.dart';
import '../../../domain/usecases/script_settings/update_script_settings.dart';
import 'script_settings_event.dart';
import 'script_settings_state.dart';

class ScriptSettingsBloc
    extends Bloc<ScriptSettingsEvent, ScriptSettingsState> {
  final GetScriptSettings getScriptSettings;
  final UpdateScriptSettings updateScriptSettings;
  List<ScriptSetting> _cachedSettings = [];
  ScriptSettingsBloc({
    required this.getScriptSettings,
    required this.updateScriptSettings,
  }) : super(ScriptSettingsInitial()) {
    on<LoadScriptSettingsEvent>(_onLoadScriptSettings);
    on<UpdateScriptSettingStatusEvent>(_onUpdateStatus);
    on<UpdateScriptSettingDateEvent>(_onUpdateDate);
    on<SaveScriptSettingsEvent>(_onSaveSettings);
  }
  Future<void> _onLoadScriptSettings(
    LoadScriptSettingsEvent event,
    Emitter<ScriptSettingsState> emit,
  ) async {
    emit(ScriptSettingsLoading());
    final result = await getScriptSettings(NoParams());
    result.fold(
      (failure) => emit(
        const ScriptSettingsError(message: 'Failed to load script settings'),
      ),
      (settings) {
        _cachedSettings = List.from(settings);
        emit(ScriptSettingsLoaded(settings: _cachedSettings));
      },
    );
  }

  void _onUpdateStatus(
    UpdateScriptSettingStatusEvent event,
    Emitter<ScriptSettingsState> emit,
  ) {
    if (state is ScriptSettingsLoaded || state is ScriptSettingsUpdateSuccess) {
      final updatedList = _cachedSettings.map((s) {
        if (s.id == event.settingId) {
          return ScriptSetting(
            id: s.id,
            symbol: s.symbol,
            updatedOn: s.updatedOn,
            updatedBy: s.updatedBy,
            isBanned: event.isBanned,
            cutDate: s.cutDate,
          );
        }
        return s;
      }).toList();
      _cachedSettings = updatedList;
      emit(ScriptSettingsLoaded(settings: _cachedSettings));
    }
  }

  void _onUpdateDate(
    UpdateScriptSettingDateEvent event,
    Emitter<ScriptSettingsState> emit,
  ) {
    if (state is ScriptSettingsLoaded || state is ScriptSettingsUpdateSuccess) {
      final updatedList = _cachedSettings.map((s) {
        if (s.id == event.settingId) {
          return ScriptSetting(
            id: s.id,
            symbol: s.symbol,
            updatedOn: s.updatedOn,
            updatedBy: s.updatedBy,
            isBanned: s.isBanned,
            cutDate: event.cutDate,
          );
        }
        return s;
      }).toList();
      _cachedSettings = updatedList;
      emit(ScriptSettingsLoaded(settings: _cachedSettings));
    }
  }

  Future<void> _onSaveSettings(
    SaveScriptSettingsEvent event,
    Emitter<ScriptSettingsState> emit,
  ) async {
    emit(ScriptSettingsLoading());
    final result = await updateScriptSettings(event.settings);
    result.fold(
      (failure) =>
          emit(const ScriptSettingsError(message: 'Failed to save settings')),
      (_) {
        _cachedSettings = List.from(event.settings);
        emit(
          ScriptSettingsUpdateSuccess(
            message: 'Settings updated successfully',
            settings: _cachedSettings,
          ),
        );
      },
    );
  }
}