import '../../../domain/entities/intraday_history/intraday_history.dart';

class IntradayHistoryModel extends IntradayHistory {
  const IntradayHistoryModel({
    required super.id,
    required super.timestamp,
    required super.open,
    required super.high,
    required super.low,
    required super.close,
    required super.volume,
  });
  factory IntradayHistoryModel.fromJson(Map<String, dynamic> json) {
    return IntradayHistoryModel(
      id: json['id']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      open: (json['open'] ?? 0).toDouble(),
      high: (json['high'] ?? 0).toDouble(),
      low: (json['low'] ?? 0).toDouble(),
      close: (json['close'] ?? 0).toDouble(),
      volume: (json['volume'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'volume': volume,
    };
  }

  factory IntradayHistoryModel.fromEntity(IntradayHistory history) {
    return IntradayHistoryModel(
      id: history.id,
      timestamp: history.timestamp,
      open: history.open,
      high: history.high,
      low: history.low,
      close: history.close,
      volume: history.volume,
    );
  }
}
