class ExpiryReportModel {
  final String exchange;
  final String symbol;
  final DateTime expiry;
  final DateTime closeDate;
  final DateTime cutDate;

  ExpiryReportModel({
    required this.exchange,
    required this.symbol,
    required this.expiry,
    required this.closeDate,
    required this.cutDate,
  });
}
