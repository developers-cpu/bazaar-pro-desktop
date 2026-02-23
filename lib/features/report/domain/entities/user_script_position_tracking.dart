import 'package:equatable/equatable.dart';

class UserScriptPositionTracking extends Equatable {
  final String id;
  final String positionDate;
  final String userName;
  final String symbol;
  final String position;
  final double openAPrice;
  final int days;
  const UserScriptPositionTracking({
    required this.id,
    required this.positionDate,
    required this.userName,
    required this.symbol,
    required this.position,
    required this.openAPrice,
    required this.days,
  });
  @override
  List<Object?> get props => [
    id,
    positionDate,
    userName,
    symbol,
    position,
    openAPrice,
    days,
  ];
}
