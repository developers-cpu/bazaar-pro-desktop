import '../../../domain/entities/user_position/user_position.dart';

class UserPositionModel extends UserPosition {
  const UserPositionModel({
    required super.exchange,
    required super.symbol,
    required super.buyQty,
    required super.sellQty,
    required super.netQty,
    required super.netAp,
    required super.cmp,
    required super.m2m,
    required super.lot,
  });
  factory UserPositionModel.fromMap(Map<String, dynamic> map) {
    return UserPositionModel(
      exchange: map['exch'] as String,
      symbol: map['symbol'] as String,
      buyQty: (map['buyQty'] as num).toDouble(),
      sellQty: (map['sellQty'] as num).toDouble(),
      netQty: (map['netQty'] as num).toDouble(),
      netAp: (map['netAp'] as num).toDouble(),
      cmp: (map['cmp'] as num).toDouble(),
      m2m: (map['m2m'] as num).toDouble(),
      lot: (map['lot'] as num).toDouble(),
    );
  }
}