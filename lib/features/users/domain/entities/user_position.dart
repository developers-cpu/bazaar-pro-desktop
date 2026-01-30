import 'package:equatable/equatable.dart';

class UserPosition extends Equatable {
  final String exchange;
  final String symbol;
  final double buyQty;
  final double sellQty;
  final double netQty;
  final double netAp;
  final double cmp;
  final double m2m;
  final double lot;

  const UserPosition({
    required this.exchange,
    required this.symbol,
    required this.buyQty,
    required this.sellQty,
    required this.netQty,
    required this.netAp,
    required this.cmp,
    required this.m2m,
    required this.lot,
  });

  @override
  List<Object?> get props => [
    exchange,
    symbol,
    buyQty,
    sellQty,
    netQty,
    netAp,
    cmp,
    m2m,
    lot,
  ];

  factory UserPosition.fromMap(Map<String, dynamic> map) {
    return UserPosition(
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
