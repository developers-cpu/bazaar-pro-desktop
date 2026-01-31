import '../../../domain/entities/user_trade_margin/user_trade_margin.dart';

class UserTradeMarginModel extends UserTradeMargin {
  const UserTradeMarginModel({
    required super.id,
    required super.exchange,
    required super.symbol,
    required super.expiryDate,
    required super.marginPercentage,
    required super.marginAmount,
    super.isSelected,
  });

  factory UserTradeMarginModel.fromJson(Map<String, dynamic> json) {
    return UserTradeMarginModel(
      id: json['id'],
      exchange: json['exchange'],
      symbol: json['symbol'],
      expiryDate: DateTime.parse(json['expiryDate']),
      marginPercentage: (json['marginPercentage'] as num).toDouble(),
      marginAmount: (json['marginAmount'] as num).toDouble(),
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'symbol': symbol,
      'expiryDate': expiryDate.toIso8601String(),
      'marginPercentage': marginPercentage,
      'marginAmount': marginAmount,
      'isSelected': isSelected,
    };
  }
}
