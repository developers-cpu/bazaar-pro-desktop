import 'package:equatable/equatable.dart';

class UserBrokerageSetting extends Equatable {
  final String id;
  final String exchange;
  final String? symbol;
  final double turnoverWiseBrk;
  final double symbolWiseBrk;

  const UserBrokerageSetting({
    required this.id,
    required this.exchange,
    this.symbol,
    required this.turnoverWiseBrk,
    required this.symbolWiseBrk,
  });

  @override
  List<Object?> get props => [
    id,
    exchange,
    symbol,
    turnoverWiseBrk,
    symbolWiseBrk,
  ];

  UserBrokerageSetting copyWith({
    String? id,
    String? exchange,
    String? symbol,
    double? turnoverWiseBrk,
    double? symbolWiseBrk,
  }) {
    return UserBrokerageSetting(
      id: id ?? this.id,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      turnoverWiseBrk: turnoverWiseBrk ?? this.turnoverWiseBrk,
      symbolWiseBrk: symbolWiseBrk ?? this.symbolWiseBrk,
    );
  }
}
