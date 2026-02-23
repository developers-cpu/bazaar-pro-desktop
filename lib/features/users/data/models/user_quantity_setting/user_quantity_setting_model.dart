import '../../../domain/entities/user_quantity_setting/user_quantity_setting.dart';

class UserQuantitySettingModel extends UserQuantitySetting {
  const UserQuantitySettingModel({
    required super.id,
    required super.symbol,
    required super.maxQty,
    required super.breakupQty,
    required super.maxLot,
    required super.breakupLot,
  });
  factory UserQuantitySettingModel.fromJson(Map<String, dynamic> json) {
    return UserQuantitySettingModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      maxQty: json['maxQty'] ?? 0,
      breakupQty: json['breakupQty'] ?? 0,
      maxLot: json['maxLot'] ?? 0,
      breakupLot: json['breakupLot'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'maxQty': maxQty,
      'breakupQty': breakupQty,
      'maxLot': maxLot,
      'breakupLot': breakupLot,
    };
  }
}
