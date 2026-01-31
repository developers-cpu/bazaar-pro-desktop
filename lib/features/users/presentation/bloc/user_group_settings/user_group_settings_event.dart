part of 'user_group_settings_bloc.dart';

abstract class UserGroupSettingsEvent {}

class LoadUserGroupSettings extends UserGroupSettingsEvent {
  final String userId;
  LoadUserGroupSettings(this.userId);
}
