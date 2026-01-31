class TradeLog {
  final String id;
  final String userName;
  final String exchange;
  final String symbol;
  final String orderUpdateType;
  final String userType;
  final double oldQty;
  final double qty;
  final double oldPrice;
  final double price;
  final DateTime updateTime;
  final DateTime orderDateTime;
  final String modifyBy;

  const TradeLog({
    required this.id,
    required this.userName,
    required this.exchange,
    required this.symbol,
    required this.orderUpdateType,
    required this.userType,
    required this.oldQty,
    required this.qty,
    required this.oldPrice,
    required this.price,
    required this.updateTime,
    required this.orderDateTime,
    required this.modifyBy,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TradeLog &&
        other.id == id &&
        other.userName == userName &&
        other.exchange == exchange &&
        other.symbol == symbol &&
        other.orderUpdateType == orderUpdateType &&
        other.userType == userType &&
        other.oldQty == oldQty &&
        other.qty == qty &&
        other.oldPrice == oldPrice &&
        other.price == price &&
        other.updateTime == updateTime &&
        other.orderDateTime == orderDateTime &&
        other.modifyBy == modifyBy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        exchange.hashCode ^
        symbol.hashCode ^
        orderUpdateType.hashCode ^
        userType.hashCode ^
        oldQty.hashCode ^
        qty.hashCode ^
        oldPrice.hashCode ^
        price.hashCode ^
        updateTime.hashCode ^
        orderDateTime.hashCode ^
        modifyBy.hashCode;
  }
}
