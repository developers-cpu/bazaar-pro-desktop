import '../../domain/entities/ban_script_entity.dart';

class BanScriptModel extends BanScriptEntity {
  const BanScriptModel({
    required super.id,
    required super.exchange,
    required super.symbol,
    required super.startTime,
    required super.banTime,
    required super.banType,
  });

  factory BanScriptModel.fromJson(Map<String, dynamic> json) {
    return BanScriptModel(
      id: json['id']?.toString() ?? '',
      exchange: json['exchange']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      banTime: json['ban_time']?.toString() ?? '',
      banType: json['ban_type']?.toString() ?? 'exchange',
    );
  }
}
