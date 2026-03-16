import 'package:equatable/equatable.dart';

class BhavCopyEntity extends Equatable {
  final String exch;
  final String symbol;
  final String expiryDate;
  final double dayHigh;
  final double dayLow;
  final double dayClose;
  const BhavCopyEntity({
    required this.exch,
    required this.symbol,
    required this.expiryDate,
    required this.dayHigh,
    required this.dayLow,
    required this.dayClose,
  });
  @override
  List<Object?> get props => [
    exch,
    symbol,
    expiryDate,
    dayHigh,
    dayLow,
    dayClose,
  ];
}
