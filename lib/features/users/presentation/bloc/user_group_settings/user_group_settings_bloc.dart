import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_group_settings/user_group_settings.dart';
import '../../../domain/usecases/user_group_settings/get_user_group_settings_usecase.dart';
part 'user_group_settings_event.dart';
part 'user_group_settings_state.dart';

class UserGroupSettingsBloc
    extends Bloc<UserGroupSettingsEvent, UserGroupSettingsState> {
  final GetUserGroupSettings getUserGroupSettings;
  UserGroupSettingsBloc({required this.getUserGroupSettings})
    : super(UserGroupSettingsInitial()) {
    on<LoadUserGroupSettings>(_onLoadUserGroupSettings);
  }
  void _onLoadUserGroupSettings(
    LoadUserGroupSettings event,
    Emitter<UserGroupSettingsState> emit,
  ) async {
    emit(UserGroupSettingsLoading());
    final result = await getUserGroupSettings(event.userId);
    result.fold(
      (failure) => emit(UserGroupSettingsError(failure.message)),
      (settings) => emit(UserGroupSettingsLoaded(settings: settings)),
    );
  }
}