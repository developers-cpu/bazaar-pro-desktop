import 'package:equatable/equatable.dart';
import '../../../domain/entities/date_settings/date_setting.dart';

abstract class DateSettingsState extends Equatable {
  const DateSettingsState();

  @override
  List<Object> get props => [];
}

class DateSettingsInitial extends DateSettingsState {}

class DateSettingsLoading extends DateSettingsState {}

class DateSettingsLoaded extends DateSettingsState {
  final List<DateSetting> settings;

  const DateSettingsLoaded(this.settings);

  @override
  List<Object> get props => [settings];
}

class DateSettingsError extends DateSettingsState {
  final String message;

  const DateSettingsError(this.message);

  @override
  List<Object> get props => [message];
}

class DateSettingsUpdateSuccess extends DateSettingsState {
  final String message;

  const DateSettingsUpdateSuccess(this.message);

  @override
  List<Object> get props => [message];
}
