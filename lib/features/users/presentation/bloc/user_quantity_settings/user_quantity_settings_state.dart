import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_quantity_setting.dart';

abstract class UserQuantitySettingsState extends Equatable {
  const UserQuantitySettingsState();

  @override
  List<Object?> get props => [];
}

class UserQuantitySettingsInitial extends UserQuantitySettingsState {}

class UserQuantitySettingsLoading extends UserQuantitySettingsState {}

class UserQuantitySettingsLoaded extends UserQuantitySettingsState {
  final List<UserQuantitySetting> allSettings;
  final List<UserQuantitySetting> filteredSettings;
  final String? selectedSymbol;

  const UserQuantitySettingsLoaded({
    required this.allSettings,
    required this.filteredSettings,
    this.selectedSymbol,
  });

  @override
  List<Object?> get props => [allSettings, filteredSettings, selectedSymbol];
}

class UserQuantitySettingsError extends UserQuantitySettingsState {
  final String message;

  const UserQuantitySettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
