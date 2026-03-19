import 'package:equatable/equatable.dart';

class BonusDividendEntry extends Equatable {
  final String id;
  final String username;
  final String symbol;
  final double netQty;
  final double closePrice;
  final String ratio;
  final double afterEffectNetQty;
  final double effectPrice;

  const BonusDividendEntry({
    required this.id,
    required this.username,
    required this.symbol,
    required this.netQty,
    required this.closePrice,
    required this.ratio,
    required this.afterEffectNetQty,
    required this.effectPrice,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    symbol,
    netQty,
    closePrice,
    ratio,
    afterEffectNetQty,
    effectPrice,
  ];
}