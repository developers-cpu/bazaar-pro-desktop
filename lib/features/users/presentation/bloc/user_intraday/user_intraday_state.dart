import 'package:equatable/equatable.dart';

abstract class UserIntradayState extends Equatable {
  const UserIntradayState();

  @override
  List<Object?> get props => [];
}

class UserIntradayLoading extends UserIntradayState {}

class UserIntradayLoaded extends UserIntradayState {
  final Map<String, bool> settings;

  const UserIntradayLoaded({required this.settings});

  UserIntradayLoaded copyWith({Map<String, bool>? settings}) {
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
