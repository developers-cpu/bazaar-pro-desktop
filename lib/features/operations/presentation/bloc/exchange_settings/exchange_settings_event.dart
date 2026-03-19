import 'package:equatable/equatable.dart';

abstract class ExchangeSettingsEvent extends Equatable {
  const ExchangeSettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadExchangeSettingsEvent extends ExchangeSettingsEvent {}

class UpdateExchangeSettingsEvent extends ExchangeSettingsEvent {
  final List<String> ids;
  const UpdateExchangeSettingsEvent({required this.ids});
  @override
  List<Object?> get props => [ids];
}

class LoadDefaultSymbolsEvent extends ExchangeSettingsEvent {
  final String exchange;
  const LoadDefaultSymbolsEvent({required this.exchange});
  @override
  List<Object?> get props => [exchange];
}