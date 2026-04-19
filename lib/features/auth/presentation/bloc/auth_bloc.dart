import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/auth_constants.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final AuthLocalDataSource authLocalDataSource;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUser,
    required this.authLocalDataSource,
    required this.authRepository,
  }) : super(const AuthCheckingSession()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<DemoLoginEvent>(_onDemoLogin);
    on<LogoutEvent>(_onLogout);
    add(const CheckAuthStatus());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final stored = await authLocalDataSource.loadSession();
    if (stored != null) {
      emit(AuthAuthenticated(user: stored));
    } else {
      emit(const AuthUnauthenticated());
    }
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
      await authLocalDataSource.saveSession(
        LoginUserModel.fromEntity(dummyUser),
      );
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
    await authLocalDataSource.saveSession(
      LoginUserModel.fromEntity(dummyUser),
    );
    emit(AuthAuthenticated(user: dummyUser));
  }

  User _createDummyUser(String role, String username) {
    return User(
      id: 'demo_${username.hashCode}',
      username: username,
      email: '${role.toLowerCase().replaceAll(' ', '')}@bazarpro.com',
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
    await authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
