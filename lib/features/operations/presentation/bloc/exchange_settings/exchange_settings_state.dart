import 'package:equatable/equatable.dart';
import '../../../domain/entities/exchange_settings/exchange_setting.dart';
import '../../../domain/entities/exchange_settings/market_timing.dart';
import '../../../domain/entities/exchange_settings/exchange_holiday.dart';
import '../../../domain/entities/exchange_settings/exchange_timing_detail.dart';

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
  final List<ExchangeMarketTiming> marketTimings;
  final List<ExchangeHoliday> holidays;
  final List<ExchangeTimingDetail> timings;

  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedExchange;

  const ExchangeSettingsLoaded(
    this.settings, {
    this.defaultSymbols = const [],
    this.marketTimings = const [],
    this.holidays = const [],
    this.timings = const [],
    this.startDate,
    this.endDate,
    this.selectedExchange,
  });
  @override
  List<Object?> get props => [
        settings,
        defaultSymbols,
        marketTimings,
        holidays,
        timings,
        startDate,
        endDate,
        selectedExchange,
      ];
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
