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
}