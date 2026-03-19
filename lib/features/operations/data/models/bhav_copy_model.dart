import '../../domain/entities/settlement_progress/bhav_copy_entity.dart';

class BhavCopyModel extends BhavCopyEntity {
  const BhavCopyModel({
    required String exch,
    required String symbol,
    required String expiryDate,
    required double dayHigh,
    required double dayLow,
    required double dayClose,
  }) : super(
         exch: exch,
         symbol: symbol,
         expiryDate: expiryDate,
         dayHigh: dayHigh,
         dayLow: dayLow,
         dayClose: dayClose,
       );
  factory BhavCopyModel.fromJson(Map<String, dynamic> json) {
    return BhavCopyModel(
      exch: json['exch'] ?? '',
      symbol: json['symbol'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      dayHigh: (json['dayHigh'] ?? 0).toDouble(),
      dayLow: (json['dayLow'] ?? 0).toDouble(),
      dayClose: (json['dayClose'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'exch': exch,
      'symbol': symbol,
      'expiryDate': expiryDate,
      'dayHigh': dayHigh,
      'dayLow': dayLow,
      'dayClose': dayClose,
    };
  }
}