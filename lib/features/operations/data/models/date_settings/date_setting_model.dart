import 'package:bazarpro/features/operations/domain/entities/date_settings/date_setting.dart';

class DateSettingModel extends DateSetting {
  const DateSettingModel({
    required super.id,
    required super.exchange,
    required super.symbol,
    required super.expiryDate,
    required super.launchDate,
    required super.closeDate,
    required super.cutDate,
    required super.updatedOn,
    required super.updatedBy,
  });

  factory DateSettingModel.fromJson(Map<String, dynamic> json) {
    return DateSettingModel(
      id: json['id'] as String,
      exchange: json['exchange'] as String,
      symbol: json['symbol'] as String,
      expiryDate: json['expiryDate'] as String,
      launchDate: json['launchDate'] as String,
      closeDate: json['closeDate'] as String,
      cutDate: json['cutDate'] as String,
      updatedOn: json['updatedOn'] as String,
      updatedBy: json['updatedBy'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'symbol': symbol,
      'expiryDate': expiryDate,
      'launchDate': launchDate,
      'closeDate': closeDate,
      'cutDate': cutDate,
      'updatedOn': updatedOn,
      'updatedBy': updatedBy,
    };
  }
}
