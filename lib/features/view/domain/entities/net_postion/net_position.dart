import 'package:equatable/equatable.dart';
class NetPosition extends Equatable {
  final String id;
  final String userName;
  final String pUser;
  final String exchange;
  final String symbol;
  final double buyQty;
  final double sellQty;
  final double netQty;
  final double netAvgPrice;
  final double cmp;
  final double m2mAmount;
  final double ourPercentage;
  final int userCount;
  final int days;
  final DateTime lastUpdated;
  final String status;
  const NetPosition({
    required this.id,
    required this.userName,
    required this.pUser,
    required this.exchange,
    required this.symbol,
    required this.buyQty,
    required this.sellQty,
    required this.netQty,
    required this.netAvgPrice,
    required this.cmp,
    required this.m2mAmount,
    required this.ourPercentage,
    required this.userCount,
    required this.days,
    required this.lastUpdated,
    required this.status,
  });
  @override
  List<Object?> get props => [
    id,
    userName,
    pUser,
    exchange,
    symbol,
    buyQty,
    sellQty,
    netQty,
    netAvgPrice,
    cmp,
    m2mAmount,
    ourPercentage,
    userCount,
    days,
    lastUpdated,
    status,
  ];
  NetPosition copyWith({
    String? id,
    String? userName,
    String? pUser,
    String? exchange,
    String? symbol,
    double? buyQty,
    double? sellQty,
    double? netQty,
    double? netAvgPrice,
    double? cmp,
    double? m2mAmount,
    double? ourPercentage,
    int? userCount,
    int? days,
    DateTime? lastUpdated,
    String? status,
  }) {
    return NetPosition(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      pUser: pUser ?? this.pUser,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      buyQty: buyQty ?? this.buyQty,
      sellQty: sellQty ?? this.sellQty,
      netQty: netQty ?? this.netQty,
      netAvgPrice: netAvgPrice ?? this.netAvgPrice,
      cmp: cmp ?? this.cmp,
      m2mAmount: m2mAmount ?? this.m2mAmount,
      ourPercentage: ourPercentage ?? this.ourPercentage,
      userCount: userCount ?? this.userCount,
      days: days ?? this.days,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      status: status ?? this.status,
    );
  }
}
