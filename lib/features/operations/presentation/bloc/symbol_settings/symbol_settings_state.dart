import '../../../domain/entities/symbol_settings/symbol_setting.dart';

abstract class SymbolSettingsState {}

class SymbolSettingsInitial extends SymbolSettingsState {}

class SymbolSettingsLoading extends SymbolSettingsState {}

class SymbolSettingsLoaded extends SymbolSettingsState {
  final List<SymbolSetting> settings;
  final String? currentExchange;

  SymbolSettingsLoaded({required this.settings, this.currentExchange});
}

class SymbolSettingsError extends SymbolSettingsState {
  final String message;
  SymbolSettingsError(this.message);
}
