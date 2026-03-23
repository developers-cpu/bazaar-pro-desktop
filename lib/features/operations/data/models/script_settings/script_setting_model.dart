import '../../../domain/entities/script_settings/script_setting.dart';

class ScriptSettingModel extends ScriptSetting {
  const ScriptSettingModel({
    required super.id,
    required super.symbol,
    required super.updatedOn,
    required super.updatedBy,
    super.isBanned = false,
    super.cutDate,
  });
  factory ScriptSettingModel.fromJson(Map<String, dynamic> json) {
    return ScriptSettingModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      updatedOn: json['updatedOn'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      isBanned: json['isBanned'] ?? false,
      cutDate: json['cutDate'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'updatedOn': updatedOn,
      'updatedBy': updatedBy,
      'isBanned': isBanned,
      'cutDate': cutDate,
    };
  }
}
