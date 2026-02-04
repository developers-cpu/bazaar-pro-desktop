import 'package:equatable/equatable.dart';
class UserBrokerageSetting extends Equatable {
  final String id;
  final String exchange;
  final String? symbol;
  final double turnoverWiseBrk;
  final double symbolWiseBrk;
  final String brokerageType;
  const UserBrokerageSetting({
    required this.id,
    required this.exchange,
    this.symbol,
    required this.turnoverWiseBrk,
    required this.symbolWiseBrk,
    this.brokerageType = 'Combined',
  });
  @override
  List<Object?> get props => [
    id,
    exchange,
    symbol,
    turnoverWiseBrk,
    symbolWiseBrk,
    brokerageType,
  ];
  UserBrokerageSetting copyWith({
    String? id,
    String? exchange,
    String? symbol,
    double? turnoverWiseBrk,
    double? symbolWiseBrk,
    String? brokerageType,
  }) {
    return UserBrokerageSetting(
      id: id ?? this.id,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      turnoverWiseBrk: turnoverWiseBrk ?? this.turnoverWiseBrk,
      symbolWiseBrk: symbolWiseBrk ?? this.symbolWiseBrk,
      brokerageType: brokerageType ?? this.brokerageType,
    );
  }
}
