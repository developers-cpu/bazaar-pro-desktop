import 'package:equatable/equatable.dart';

/// Base class for all auth events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to login user
class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  final int expiresInMins;

  const LoginEvent({
    required this.username,
    required this.password,
    this.expiresInMins = 30,
  });

  @override
  List<Object?> get props => [username, password, expiresInMins];
}

/// Event for demo login (with predefined credentials)
class DemoLoginEvent extends AuthEvent {
  const DemoLoginEvent();
}

/// Event to logout user
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Event to refresh token
class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;

  const RefreshTokenEvent({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}