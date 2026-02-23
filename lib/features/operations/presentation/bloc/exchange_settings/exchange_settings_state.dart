import 'package:equatable/equatable.dart';
import '../../../domain/entities/exchange_settings/exchange_setting.dart';


abstract class ExchangeSettingsState extends Equatable {
  const ExchangeSettingsState();

  @override
  List<Object?> get props => [];
}

class ExchangeSettingsInitial extends ExchangeSettingsState {}

class ExchangeSettingsLoading extends ExchangeSettingsState {}

class ExchangeSettingsLoaded extends ExchangeSettingsState {
  final List<ExchangeSetting> settings;
  final List<DefaultSymbol> defaultSymbols;

  const ExchangeSettingsLoaded(this.settings, {this.defaultSymbols = const []});

  @override
  List<Object?> get props => [settings, defaultSymbols];
}

class ExchangeSettingsError extends ExchangeSettingsState {
  final String message;

  const ExchangeSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExchangeSettingsUpdateSuccess extends ExchangeSettingsState {
  final String message;

  const ExchangeSettingsUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
