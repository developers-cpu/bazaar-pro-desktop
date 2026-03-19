import '../../../domain/entities/user_brokerage_setting/user_brokerage_setting.dart';

class UserBrokerageSettingModel extends UserBrokerageSetting {
  const UserBrokerageSettingModel({
    required super.id,
    required super.exchange,
    required super.symbol,
    required super.turnoverWiseBrk,
    required super.symbolWiseBrk,
    required super.brokerageType,
  });
  factory UserBrokerageSettingModel.fromMap(Map<String, dynamic> map) {
    return UserBrokerageSettingModel(
      id: map['id'] ?? '',
      exchange: map['exchange'] ?? '',
      symbol: map['symbol'],
      turnoverWiseBrk: (map['turnoverWiseBrk'] as num).toDouble(),
      symbolWiseBrk: (map['symbolWiseBrk'] as num).toDouble(),
      brokerageType: map['brokerageType'] ?? 'Combined',
    );
  }
}