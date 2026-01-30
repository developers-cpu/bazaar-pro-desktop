import 'package:equatable/equatable.dart';

abstract class UserIntradayEvent extends Equatable {
  const UserIntradayEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserIntradaySettings extends UserIntradayEvent {
  final String userId;
  const LoadUserIntradaySettings(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ToggleIntradaySetting extends UserIntradayEvent {
  final String key;
  final bool value;

  const ToggleIntradaySetting(this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}
