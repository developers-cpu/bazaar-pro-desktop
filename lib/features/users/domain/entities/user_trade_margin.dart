import 'package:equatable/equatable.dart';

class UserTradeMargin extends Equatable {
  final String id;
  final String exchange;
  final String symbol;
  final DateTime expiryDate;
  final double marginPercentage;
  final double marginAmount;
  final bool isSelected;

  const UserTradeMargin({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.expiryDate,
    required this.marginPercentage,
    required this.marginAmount,
    this.isSelected = false,
  });

  UserTradeMargin copyWith({
    String? id,
    String? exchange,
    String? symbol,
    DateTime? expiryDate,
    double? marginPercentage,
    double? marginAmount,
    bool? isSelected,
  }) {
    return UserTradeMargin(
      id: id ?? this.id,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      expiryDate: expiryDate ?? this.expiryDate,
      marginPercentage: marginPercentage ?? this.marginPercentage,
      marginAmount: marginAmount ?? this.marginAmount,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [
    id,
    exchange,
    symbol,
    expiryDate,
    marginPercentage,
    marginAmount,
    isSelected,
  ];
}
