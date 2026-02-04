import '../../../domain/entities/net_postion/net_position.dart';
class NetPositionModel extends NetPosition {
  const NetPositionModel({
    required super.id,
    required super.userName,
    required super.pUser,
    required super.exchange,
    required super.symbol,
    required super.buyQty,
    required super.sellQty,
    required super.netQty,
    required super.netAvgPrice,
    required super.cmp,
    required super.m2mAmount,
    required super.ourPercentage,
    required super.userCount,
    required super.days,
    required super.lastUpdated,
    required super.status,
  });
  factory NetPositionModel.fromJson(Map<String, dynamic> json) {
    return NetPositionModel(
      id: json['id']?.toString() ?? '',
      userName: json['userName'] ?? json['u_name'] ?? '',
      pUser: json['pUser'] ?? json['p_user'] ?? '',
      exchange: json['exchange'] ?? json['exch'] ?? '',
      symbol: json['symbol'] ?? '',
      buyQty: (json['buyQty'] ?? json['buy_qty'] ?? 0).toDouble(),
      sellQty: (json['sellQty'] ?? json['sell_qty'] ?? 0).toDouble(),
      netQty: (json['netQty'] ?? json['net_qty'] ?? 0).toDouble(),
      netAvgPrice: (json['netAvgPrice'] ?? json['net_avg_price'] ?? 0).toDouble(),
      cmp: (json['cmp'] ?? 0).toDouble(),
      m2mAmount: (json['m2mAmount'] ?? json['m2m_amt'] ?? 0).toDouble(),
      ourPercentage: (json['ourPercentage'] ?? json['our_percentage'] ?? 0).toDouble(),
      userCount: (json['userCount'] ?? json['user_count'] ?? 1).toInt(),
      days: (json['days'] ?? 1).toInt(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
      status: json['status'] ?? 'Active',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'pUser': pUser,
      'exchange': exchange,
      'symbol': symbol,
      'buyQty': buyQty,
      'sellQty': sellQty,
      'netQty': netQty,
      'netAvgPrice': netAvgPrice,
      'cmp': cmp,
      'm2mAmount': m2mAmount,
      'ourPercentage': ourPercentage,
      'userCount': userCount,
      'days': days,
      'lastUpdated': lastUpdated.toIso8601String(),
      'status': status,
    };
  }
  factory NetPositionModel.fromEntity(NetPosition position) {
    return NetPositionModel(
      id: position.id,
      userName: position.userName,
      pUser: position.pUser,
      exchange: position.exchange,
      symbol: position.symbol,
      buyQty: position.buyQty,
      sellQty: position.sellQty,
      netQty: position.netQty,
      netAvgPrice: position.netAvgPrice,
      cmp: position.cmp,
      m2mAmount: position.m2mAmount,
      ourPercentage: position.ourPercentage,
      userCount: position.userCount,
      days: position.days,
      lastUpdated: position.lastUpdated,
      status: position.status,
    );
  }
}
