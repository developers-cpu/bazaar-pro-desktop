import 'package:equatable/equatable.dart';

class ScriptMaster extends Equatable {
  final String id;
  final String exchange;
  final String symbol;
  final DateTime expiryDate;
  final String tradeAttribute;
  final bool allowTrade;
  final DateTime lastUpdated;
  const ScriptMaster({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.expiryDate,
    required this.tradeAttribute,
    required this.allowTrade,
    required this.lastUpdated,
  });
  @override
  List<Object?> get props => [
    id,
    exchange,
    symbol,
    expiryDate,
    tradeAttribute,
    allowTrade,
    lastUpdated,
  ];
  ScriptMaster copyWith({
    String? id,
    String? exchange,
    String? symbol,
    DateTime? expiryDate,
    String? tradeAttribute,
    bool? allowTrade,
    DateTime? lastUpdated,
  }) {
    return ScriptMaster(
      id: id ?? this.id,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      expiryDate: expiryDate ?? this.expiryDate,
      tradeAttribute: tradeAttribute ?? this.tradeAttribute,
      allowTrade: allowTrade ?? this.allowTrade,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
