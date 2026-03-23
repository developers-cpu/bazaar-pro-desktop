import 'package:equatable/equatable.dart';

class UserTradeMargin extends Equatable {
  final String id;
  final String exchange;
  final String symbol;
  final DateTime expiryDate;
  final double intradayMarginPercentage;
  final double intradayMarginAmount;
  final double carryForwardMarginPercentage;
  final double carryForwardMarginAmount;
  final bool isSelected;
  const UserTradeMargin({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.expiryDate,
    required this.intradayMarginPercentage,
    required this.intradayMarginAmount,
    required this.carryForwardMarginPercentage,
    required this.carryForwardMarginAmount,
    this.isSelected = false,
  });
  UserTradeMargin copyWith({
    String? id,
    String? exchange,
    String? symbol,
    DateTime? expiryDate,
    double? intradayMarginPercentage,
    double? intradayMarginAmount,
    double? carryForwardMarginPercentage,
    double? carryForwardMarginAmount,
    bool? isSelected,
  }) {
    return UserTradeMargin(
      id: id ?? this.id,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      expiryDate: expiryDate ?? this.expiryDate,
      intradayMarginPercentage:
          intradayMarginPercentage ?? this.intradayMarginPercentage,
      intradayMarginAmount: intradayMarginAmount ?? this.intradayMarginAmount,
      carryForwardMarginPercentage:
          carryForwardMarginPercentage ?? this.carryForwardMarginPercentage,
      carryForwardMarginAmount:
          carryForwardMarginAmount ?? this.carryForwardMarginAmount,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [
    id,
    exchange,
    symbol,
    expiryDate,
    intradayMarginPercentage,
    intradayMarginAmount,
    carryForwardMarginPercentage,
    carryForwardMarginAmount,
    isSelected,
  ];
}
