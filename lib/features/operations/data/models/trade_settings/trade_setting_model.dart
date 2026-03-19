import 'package:bazarpro/features/operations/domain/entities/trade_settings/trade_setting.dart';

class TradeSettingModel extends TradeSetting {
  const TradeSettingModel({
    required super.id,
    required super.exchange,
    super.symbol,
    super.marginType,
    super.intMarginPercentage,
    super.cfMarginPercentage,
    super.intMarginAmt,
    super.cfMarginAmt,
    super.brokerageType,
    super.turnoverWiseBrokerageRs,
    super.lotWiseBrokerageAmt,
    super.leverageMultiplier,
    super.tradeSecondsLimit,
    required super.updatedOn,
    required super.updatedBy,
  });
  factory TradeSettingModel.fromJson(Map<String, dynamic> json) {
    return TradeSettingModel(
      id: json['id'] as String,
      exchange: json['exchange'] as String,
      symbol: json['symbol'] as String?,
      marginType: json['marginType'] as String?,
      intMarginPercentage: json['intMarginPercentage'] as String?,
      cfMarginPercentage: json['cfMarginPercentage'] as String?,
      intMarginAmt: json['intMarginAmt'] as String?,
      cfMarginAmt: json['cfMarginAmt'] as String?,
      brokerageType: json['brokerageType'] as String?,
      turnoverWiseBrokerageRs: json['turnoverWiseBrokerageRs'] as String?,
      lotWiseBrokerageAmt: json['lotWiseBrokerageAmt'] as String?,
      leverageMultiplier: json['leverageMultiplier'] as String?,
      tradeSecondsLimit: json['tradeSecondsLimit'] as String?,
      updatedOn: json['updatedOn'] as String,
      updatedBy: json['updatedBy'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'symbol': symbol,
      'marginType': marginType,
      'intMarginPercentage': intMarginPercentage,
      'cfMarginPercentage': cfMarginPercentage,
      'intMarginAmt': intMarginAmt,
      'cfMarginAmt': cfMarginAmt,
      'brokerageType': brokerageType,
      'turnoverWiseBrokerageRs': turnoverWiseBrokerageRs,
      'lotWiseBrokerageAmt': lotWiseBrokerageAmt,
      'leverageMultiplier': leverageMultiplier,
      'tradeSecondsLimit': tradeSecondsLimit,
      'updatedOn': updatedOn,
      'updatedBy': updatedBy,
    };
  }
}