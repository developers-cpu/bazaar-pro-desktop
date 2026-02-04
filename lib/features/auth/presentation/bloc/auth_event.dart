import 'package:equatable/equatable.dart';
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}
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
class DemoLoginEvent extends AuthEvent {
  const DemoLoginEvent();
}
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;
  const RefreshTokenEvent({required this.refreshToken});
  @override
  List<Object?> get props => [refreshToken];
}
