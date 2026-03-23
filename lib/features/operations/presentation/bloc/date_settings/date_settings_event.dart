import 'package:equatable/equatable.dart';
import '../../../domain/entities/date_settings/date_setting.dart';

abstract class DateSettingsEvent extends Equatable {
  const DateSettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadDateSettingsEvent extends DateSettingsEvent {}

class UpdateDateSettingsEvent extends DateSettingsEvent {
  final List<String> ids;
  final DateSetting? details;
  const UpdateDateSettingsEvent({required this.ids, this.details});
  @override
  List<Object> get props => [ids];
}
