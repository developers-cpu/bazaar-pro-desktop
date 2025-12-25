import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/auth_constants.dart';
import '../../domain/usecases/login_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for managing authentication state
/// Handles login, logout, and token refresh
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;

  AuthBloc({
    required this.loginUser,
  }) : super(const AuthInitial()) {
    // Register event handlers
    on<LoginEvent>(_onLogin);
    on<DemoLoginEvent>(_onDemoLogin);
    on<LogoutEvent>(_onLogout);
  }

  /// Handle login event
  Future<void> _onLogin(
      LoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

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

  /// Handle demo login event
  Future<void> _onDemoLogin(
      DemoLoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await loginUser(
      const LoginParams(
        username: AuthConstants.demoUsername,
        password: AuthConstants.demoPassword,
        expiresInMins: AuthConstants.tokenExpiryMinutes,
      ),
    );

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Handle logout event
  Future<void> _onLogout(
      LogoutEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthUnauthenticated());
  }
}