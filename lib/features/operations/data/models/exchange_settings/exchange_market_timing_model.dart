import '../../../domain/entities/exchange_settings/market_timing.dart';

class ExchangeMarketTimingModel extends ExchangeMarketTiming {
  const ExchangeMarketTimingModel({
    required super.id,
    required super.exchange,
    required super.date,
    required super.isOn,
    required super.timing,
  });

  factory ExchangeMarketTimingModel.fromJson(Map<String, dynamic> json) {
    return ExchangeMarketTimingModel(
      id: json['id'] as String,
      exchange: json['exchange'] as String,
      date: json['date'] as String,
      isOn: json['isOn'] as bool,
      timing: json['timing'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'date': date,
      'isOn': isOn,
      'timing': timing,
    };
  }
}
