

import '../../../domain/entities/exchange_settings/exchange_holiday.dart';

class ExchangeHolidayModel extends ExchangeHoliday {
  const ExchangeHolidayModel({
    required super.id,
    required super.date,
    required super.remark,
    required super.exchange,
  });

  factory ExchangeHolidayModel.fromJson(Map<String, dynamic> json) {
    return ExchangeHolidayModel(
      id: json['id'] as String,
      date: json['date'] as String,
      remark: json['remark'] as String,
      exchange: json['exchange'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'remark': remark,
      'exchange': exchange,
    };
  }
}
