import 'package:equatable/equatable.dart';
class TradeSetting extends Equatable {
  final String id;
  final String exchange;
  final String? marginType;
  final String? intMarginPercentage;
  final String? cfMarginPercentage;
  final String? intMarginAmt;
  final String? cfMarginAmt;
  final String? brokerageType;
  final String? turnoverWiseBrokerageRs;
  final String? lotWiseBrokerageAmt;
  final String? leverageMultiplier;
  final String? tradeSecondsLimit;
  final String updatedOn;
  final String updatedBy;
  const TradeSetting({
    required this.id,
    required this.exchange,
    this.marginType,
    this.intMarginPercentage,
    this.cfMarginPercentage,
    this.intMarginAmt,
    this.cfMarginAmt,
    this.brokerageType,
    this.turnoverWiseBrokerageRs,
    this.lotWiseBrokerageAmt,
    this.leverageMultiplier,
    this.tradeSecondsLimit,
    required this.updatedOn,
    required this.updatedBy,
  });
  @override
  List<Object?> get props => [
    id,
    exchange,
    marginType,
    intMarginPercentage,
    cfMarginPercentage,
    intMarginAmt,
    cfMarginAmt,
    brokerageType,
    turnoverWiseBrokerageRs,
    lotWiseBrokerageAmt,
    leverageMultiplier,
    tradeSecondsLimit,
    updatedOn,
    updatedBy,
  ];
}
