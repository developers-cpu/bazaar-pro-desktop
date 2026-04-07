class SurveillanceBulkOrder {
  final String id;
  final String exchange;
  final String symbol;
  final int intervalTime;
  final int totalQuantity;
  final double tradeSlLimit;
  final String updatedOn;
  final String updatedBy;
  const SurveillanceBulkOrder({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.intervalTime,
    required this.totalQuantity,
    required this.tradeSlLimit,
    required this.updatedOn,
    required this.updatedBy,
  });

  SurveillanceBulkOrder copyWith({
    String? id,
    String? exchange,
    String? symbol,
    int? intervalTime,
    int? totalQuantity,
    double? tradeSlLimit,
    String? updatedOn,
    String? updatedBy,
  }) {
    return SurveillanceBulkOrder(
      id: id ?? this.id,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      intervalTime: intervalTime ?? this.intervalTime,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      tradeSlLimit: tradeSlLimit ?? this.tradeSlLimit,
      updatedOn: updatedOn ?? this.updatedOn,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}
