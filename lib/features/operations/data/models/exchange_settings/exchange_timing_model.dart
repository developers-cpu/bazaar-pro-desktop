

import '../../../domain/entities/exchange_settings/exchange_timing_detail.dart';

class ExchangeTimingModel extends ExchangeTimingDetail {
  const ExchangeTimingModel({
    required super.id,
    required super.days,
    required super.startTime,
    required super.endTime,
    required super.remark,
    required super.exchange,
  });

  factory ExchangeTimingModel.fromJson(Map<String, dynamic> json) {
    return ExchangeTimingModel(
      id: json['id'] as String,
      days: (json['days'] as List).map((e) => e as String).toList(),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      remark: json['remark'] as String,
      exchange: json['exchange'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'days': days,
      'startTime': startTime,
      'endTime': endTime,
      'remark': remark,
      'exchange': exchange,
    };
  }
}
