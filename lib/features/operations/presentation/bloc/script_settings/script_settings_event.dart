import 'package:equatable/equatable.dart';
import '../../../domain/entities/script_settings/script_setting.dart';

abstract class ScriptSettingsEvent extends Equatable {
  const ScriptSettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadScriptSettingsEvent extends ScriptSettingsEvent {}

class UpdateScriptSettingStatusEvent extends ScriptSettingsEvent {
  final String settingId;
  final bool isBanned;
  const UpdateScriptSettingStatusEvent({
    required this.settingId,
    required this.isBanned,
  });
  @override
  List<Object?> get props => [settingId, isBanned];
}

class UpdateScriptSettingDateEvent extends ScriptSettingsEvent {
  final String settingId;
  final String cutDate;
  const UpdateScriptSettingDateEvent({
    required this.settingId,
    required this.cutDate,
  });
  @override
  List<Object?> get props => [settingId, cutDate];
}

class SaveScriptSettingsEvent extends ScriptSettingsEvent {
  final List<ScriptSetting> settings;
  const SaveScriptSettingsEvent(this.settings);
  @override
  List<Object?> get props => [settings];
}