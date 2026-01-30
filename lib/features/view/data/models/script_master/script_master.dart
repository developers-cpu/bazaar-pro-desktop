import '../../../domain/entities/script_master/script_master.dart';


class ScriptMasterModel extends ScriptMaster {
  const ScriptMasterModel({
    required super.id,
    required super.exchange,
    required super.symbol,
    required super.expiryDate,
    required super.tradeAttribute,
    required super.allowTrade,
    required super.lastUpdated,
  });

  factory ScriptMasterModel.fromJson(Map<String, dynamic> json) {
    return ScriptMasterModel(
      id: json['id']?.toString() ?? '',
      exchange: json['exchange'] ?? json['exch'] ?? '',
      symbol: json['symbol'] ?? '',
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : DateTime.now(),
      tradeAttribute: json['tradeAttribute'] ?? json['trade_attr'] ?? 'full',
      allowTrade: json['allowTrade'] ?? json['allow_trade'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'symbol': symbol,
      'expiryDate': expiryDate.toIso8601String(),
      'tradeAttribute': tradeAttribute,
      'allowTrade': allowTrade,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  
  factory ScriptMasterModel.fromEntity(ScriptMaster script) {
    return ScriptMasterModel(
      id: script.id,
      exchange: script.exchange,
      symbol: script.symbol,
      expiryDate: script.expiryDate,
      tradeAttribute: script.tradeAttribute,
      allowTrade: script.allowTrade,
      lastUpdated: script.lastUpdated,
    );
  }
}