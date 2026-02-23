part of 'user_group_settings_bloc.dart';
abstract class UserGroupSettingsState {}
class UserGroupSettingsInitial extends UserGroupSettingsState {}
class UserGroupSettingsLoading extends UserGroupSettingsState {}
class UserGroupSettingsLoaded extends UserGroupSettingsState {
  final List<UserGroupSettings> settings;
  UserGroupSettingsLoaded({required this.settings});
}
class UserGroupSettingsError extends UserGroupSettingsState {
  final String message;
  UserGroupSettingsError(this.message);
}
