import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_intraday_square_off/user_intraday_square_off.dart';

abstract class UserIntradayState extends Equatable {
  const UserIntradayState();
  @override
  List<Object?> get props => [];
}

class UserIntradayLoading extends UserIntradayState {}

class UserIntradayLoaded extends UserIntradayState {
  final List<UserIntradaySquareOff> settings;
  const UserIntradayLoaded({required this.settings});
  UserIntradayLoaded copyWith({List<UserIntradaySquareOff>? settings}) {
    return UserIntradayLoaded(settings: settings ?? this.settings);
  }

  @override
  List<Object?> get props => [settings];
}

class UserIntradayError extends UserIntradayState {
  final String message;
  const UserIntradayError(this.message);
  @override
  List<Object?> get props => [message];
}