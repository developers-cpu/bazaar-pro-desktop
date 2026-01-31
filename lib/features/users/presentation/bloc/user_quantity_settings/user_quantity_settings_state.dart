import 'package:bazarpro/features/users/domain/entities/user_quantity_setting/user_quantity_setting.dart';
import 'package:bazarpro/features/users/domain/entities/user_quantity_setting/user_quantity_setting_metadata.dart';
import 'package:equatable/equatable.dart';

abstract class UserQuantitySettingsState extends Equatable {
  const UserQuantitySettingsState();

  @override
  List<Object?> get props => [];
}

class UserQuantitySettingsInitial extends UserQuantitySettingsState {}

class UserQuantitySettingsLoading extends UserQuantitySettingsState {}

class UserQuantitySettingsLoaded extends UserQuantitySettingsState {
  final List<UserQuantitySetting> settings;
  final List<UserQuantitySetting> filteredSettings;
  final UserQuantitySettingMetadata? metadata;
  final String? selectedSymbol;

  const UserQuantitySettingsLoaded({
    required this.settings,
    required this.filteredSettings,
    this.metadata,
    this.selectedSymbol,
  });

  UserQuantitySettingsLoaded copyWith({
    List<UserQuantitySetting>? settings,
    List<UserQuantitySetting>? filteredSettings,
    UserQuantitySettingMetadata? metadata,
    String? selectedSymbol,
  }) {
    return UserQuantitySettingsLoaded(
      settings: settings ?? this.settings,
      filteredSettings: filteredSettings ?? this.filteredSettings,
      metadata: metadata ?? this.metadata,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
    );
  }

  @override
  List<Object?> get props => [
    settings,
    filteredSettings,
    metadata,
    selectedSymbol,
  ];
}

class UserQuantitySettingsError extends UserQuantitySettingsState {
  final String message;

  const UserQuantitySettingsError(this.message);

  @override
  List<Object> get props => [message];
}
