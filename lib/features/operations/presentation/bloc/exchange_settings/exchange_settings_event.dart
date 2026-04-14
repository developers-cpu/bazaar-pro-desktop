import 'package:equatable/equatable.dart';
import '../../../domain/entities/exchange_settings/exchange_holiday.dart';
import '../../../domain/entities/exchange_settings/exchange_timing_detail.dart';
import '../../../domain/entities/exchange_settings/market_timing.dart';

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

class LoadMarketTimingsEvent extends ExchangeSettingsEvent {}

class UpdateMarketTimingsFromExcelEvent extends ExchangeSettingsEvent {
  final List<int> bytes;
  const UpdateMarketTimingsFromExcelEvent({required this.bytes});
  @override
  List<Object?> get props => [bytes];
}

class UpdateMarketTimingStatusEvent extends ExchangeSettingsEvent {
  final String id;
  final bool isOn;
  const UpdateMarketTimingStatusEvent({required this.id, required this.isOn});
  @override
  List<Object?> get props => [id, isOn];
}

class LoadExchangeHolidaysEvent extends ExchangeSettingsEvent {
  final String exchange;
  const LoadExchangeHolidaysEvent({required this.exchange});
  @override
  List<Object?> get props => [exchange];
}

class UpdateExchangeHolidayEvent extends ExchangeSettingsEvent {
  final ExchangeHoliday holiday;
  const UpdateExchangeHolidayEvent({required this.holiday});
  @override
  List<Object?> get props => [holiday];
}

class DeleteExchangeHolidayEvent extends ExchangeSettingsEvent {
  final String id;
  final String exchange;
  const DeleteExchangeHolidayEvent({required this.id, required this.exchange});
  @override
  List<Object?> get props => [id, exchange];
}

class LoadExchangeTimingsEvent extends ExchangeSettingsEvent {
  final String exchange;
  const LoadExchangeTimingsEvent({required this.exchange});
  @override
  List<Object?> get props => [exchange];
}

class UpdateExchangeTimingEvent extends ExchangeSettingsEvent {
  final ExchangeTimingDetail timing;
  const UpdateExchangeTimingEvent({required this.timing});
  @override
  List<Object?> get props => [timing];
}

class DeleteExchangeTimingEvent extends ExchangeSettingsEvent {
  final String id;
  final String exchange;
  const DeleteExchangeTimingEvent({required this.id, required this.exchange});
  @override
  List<Object?> get props => [id, exchange];
}

class UpdateMarketTimingFiltersEvent extends ExchangeSettingsEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? exchange;
  const UpdateMarketTimingFiltersEvent({
    this.startDate,
    this.endDate,
    this.exchange,
  });
  @override
  List<Object?> get props => [startDate, endDate, exchange];
}

class ApplyMarketTimingFiltersEvent extends ExchangeSettingsEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? exchange;
  const ApplyMarketTimingFiltersEvent({
    this.startDate,
    this.endDate,
    this.exchange,
  });
  @override
  List<Object?> get props => [startDate, endDate, exchange];
}

class ResetMarketTimingFiltersEvent extends ExchangeSettingsEvent {
  const ResetMarketTimingFiltersEvent();
}
