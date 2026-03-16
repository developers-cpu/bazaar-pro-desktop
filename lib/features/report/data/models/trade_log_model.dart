import '../../domain/entities/trade_log.dart';
class TradeLogModel extends TradeLog {
  const TradeLogModel({
    required String id,
    required String userName,
    required String exchange,
    required String symbol,
    required String orderUpdateType,
    required String userType,
    required double oldQty,
    required double qty,
    required double oldPrice,
    required double price,
    required DateTime updateTime,
    required DateTime orderDateTime,
    required String modifyBy,
  }) : super(
         id: id,
         userName: userName,
         exchange: exchange,
         symbol: symbol,
         orderUpdateType: orderUpdateType,
         userType: userType,
         oldQty: oldQty,
         qty: qty,
         oldPrice: oldPrice,
         price: price,
         updateTime: updateTime,
         orderDateTime: orderDateTime,
         modifyBy: modifyBy,
       );
  factory TradeLogModel.fromJson(Map<String, dynamic> json) {
    return TradeLogModel(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      userName: json['userName'] as String? ?? '',
      exchange: json['exchange'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      orderUpdateType: json['orderUpdateType'] as String? ?? '',
      userType: json['userType'] as String? ?? '',
      oldQty: (json['oldQty'] as num?)?.toDouble() ?? 0.0,
      qty: (json['qty'] as num?)?.toDouble() ?? 0.0,
      oldPrice: (json['oldPrice'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'] as String)
          : DateTime.now(),
      orderDateTime: json['orderDateTime'] != null
          ? DateTime.parse(json['orderDateTime'] as String)
          : DateTime.now(),
      modifyBy: json['modifyBy'] as String? ?? '',
    );
  }
}
