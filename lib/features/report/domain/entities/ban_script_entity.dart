import 'package:equatable/equatable.dart';

class BanScriptEntity extends Equatable {
  final String id;
  final String exchange;
  final String symbol;
  final String startTime;
  final String banTime;
  final String banType;

  const BanScriptEntity({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.startTime,
    required this.banTime,
    required this.banType,
  });

  @override
  List<Object?> get props => [id, exchange, symbol, startTime, banTime, banType];
}
