import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../../../../core/constants/auth_constants.dart';
import '../../domain/usecases/login_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  AuthBloc({required this.loginUser}) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<DemoLoginEvent>(_onDemoLogin);
    on<LogoutEvent>(_onLogout);
  }
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    User? dummyUser;
    if (event.username == AuthConstants.clientUsername &&
        event.password == AuthConstants.clientPassword) {
      dummyUser = _createDummyUser('Client', event.username);
    } else if (event.username == AuthConstants.masterUsername &&
        event.password == AuthConstants.masterPassword) {
      dummyUser = _createDummyUser('Master', event.username);
    } else if (event.username == AuthConstants.adminUsername &&
        event.password == AuthConstants.adminPassword) {
      dummyUser = _createDummyUser('Admin', event.username);
    } else if (event.username == AuthConstants.superAdminUsername &&
        event.password == AuthConstants.superAdminPassword) {
      dummyUser = _createDummyUser('Super Admin', event.username);
    }
    if (dummyUser != null) {
      emit(AuthAuthenticated(user: dummyUser));
      return;
    }
    final result = await loginUser(
      LoginParams(
        username: event.username,
        password: event.password,
        expiresInMins: event.expiresInMins,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }
  Future<void> _onDemoLogin(
    DemoLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final dummyUser = _createDummyUser(event.role, event.role.toLowerCase());
    emit(AuthAuthenticated(user: dummyUser));
  }
  User _createDummyUser(String role, String username) {
    return User(
      id: 0,
      username: username,
      email: '${role.toLowerCase()}@bazarpro.com',
      firstName: role,
      lastName: 'User',
      gender: 'male',
      image: '',
      accessToken: 'dummy_token',
      refreshToken: 'dummy_refresh_token',
      role: role,
    );
  }
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthUnauthenticated());
  }
}
