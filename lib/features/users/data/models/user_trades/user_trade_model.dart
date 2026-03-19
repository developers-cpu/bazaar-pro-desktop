import '../../../domain/entities/user_trades/user_trade.dart';

class UserTradeModel extends UserTrade {
  const UserTradeModel({
    required super.id,
    required super.userName,
    required super.parentUser,
    required super.exchange,
    required super.symbol,
    required super.buySell,
    required super.tradeType,
    required super.quantity,
    required super.lot,
    required super.profitLoss,
    required super.validity,
    required super.tradePrice,
    required super.brokerage,
    required super.netPrice,
    required super.orderTime,
    required super.executionTime,
    required super.requestPrice,
    required super.orderDuration,
  });
  factory UserTradeModel.fromJson(Map<String, dynamic> json) {
    return UserTradeModel(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      parentUser: json['parentUser'] ?? '',
      exchange: json['exchange'] ?? '',
      symbol: json['symbol'] ?? '',
      buySell: json['buySell'] ?? '',
      tradeType: json['tradeType'] ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      lot: (json['lot'] as num?)?.toDouble() ?? 0.0,
      profitLoss: (json['profitLoss'] as num?)?.toDouble() ?? 0.0,
      validity: json['validity'] ?? '',
      tradePrice: (json['tradePrice'] as num?)?.toDouble() ?? 0.0,
      brokerage: (json['brokerage'] as num?)?.toDouble() ?? 0.0,
      netPrice: (json['netPrice'] as num?)?.toDouble() ?? 0.0,
      orderTime: DateTime.tryParse(json['orderTime'] ?? '') ?? DateTime.now(),
      executionTime:
          DateTime.tryParse(json['executionTime'] ?? '') ?? DateTime.now(),
      requestPrice: (json['requestPrice'] as num?)?.toDouble() ?? 0.0,
      orderDuration: json['orderDuration'] ?? '',
    );
  }
}