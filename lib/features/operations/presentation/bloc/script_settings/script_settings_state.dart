import 'package:equatable/equatable.dart';
import '../../../domain/entities/script_settings/script_setting.dart';

abstract class ScriptSettingsState extends Equatable {
  const ScriptSettingsState();
  @override
  List<Object?> get props => [];
}

class ScriptSettingsInitial extends ScriptSettingsState {}

class ScriptSettingsLoading extends ScriptSettingsState {}

class ScriptSettingsLoaded extends ScriptSettingsState {
  final List<ScriptSetting> settings;
  const ScriptSettingsLoaded({required this.settings});
  @override
  List<Object?> get props => [settings];
}

class ScriptSettingsUpdateSuccess extends ScriptSettingsState {
  final String message;
  final List<ScriptSetting> settings;
  const ScriptSettingsUpdateSuccess({
    required this.message,
    required this.settings,
  });
  @override
  List<Object?> get props => [message, settings];
}

class ScriptSettingsError extends ScriptSettingsState {
  final String message;
  const ScriptSettingsError({required this.message});
  @override
  List<Object?> get props => [message];
}