import 'package:equatable/equatable.dart';

class UserQuantitySetting extends Equatable {
  final String id;
  final String symbol;
  final int maxQty;
  final int breakupQty;
  final int maxLot;
  final int breakupLot;
  const UserQuantitySetting({
    required this.id,
    required this.symbol,
    required this.maxQty,
    required this.breakupQty,
    required this.maxLot,
    required this.breakupLot,
  });
  @override
  List<Object?> get props => [
    id,
    symbol,
    maxQty,
    breakupQty,
    maxLot,
    breakupLot,
  ];
}
