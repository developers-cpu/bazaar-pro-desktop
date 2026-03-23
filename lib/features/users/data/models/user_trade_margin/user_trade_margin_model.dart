import '../../../domain/entities/user_trade_margin/user_trade_margin.dart';

class UserTradeMarginModel extends UserTradeMargin {
  const UserTradeMarginModel({
    required super.id,
    required super.exchange,
    required super.symbol,
    required super.expiryDate,
    required super.intradayMarginPercentage,
    required super.intradayMarginAmount,
    required super.carryForwardMarginPercentage,
    required super.carryForwardMarginAmount,
    super.isSelected,
  });
  factory UserTradeMarginModel.fromJson(Map<String, dynamic> json) {
    return UserTradeMarginModel(
      id: json['id'],
      exchange: json['exchange'],
      symbol: json['symbol'],
      expiryDate: DateTime.parse(json['expiryDate']),
      intradayMarginPercentage: (json['intradayMarginPercentage'] as num)
          .toDouble(),
      intradayMarginAmount: (json['intradayMarginAmount'] as num).toDouble(),
      carryForwardMarginPercentage:
          (json['carryForwardMarginPercentage'] as num).toDouble(),
      carryForwardMarginAmount: (json['carryForwardMarginAmount'] as num)
          .toDouble(),
      isSelected: json['isSelected'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'symbol': symbol,
      'expiryDate': expiryDate.toIso8601String(),
      'intradayMarginPercentage': intradayMarginPercentage,
      'intradayMarginAmount': intradayMarginAmount,
      'carryForwardMarginPercentage': carryForwardMarginPercentage,
      'carryForwardMarginAmount': carryForwardMarginAmount,
      'isSelected': isSelected,
    };
  }
}
