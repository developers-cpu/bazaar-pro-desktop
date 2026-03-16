import 'package:equatable/equatable.dart';
class IntradayHistory extends Equatable {
  final String id;
  final DateTime timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  const IntradayHistory({
    required this.id,
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
  @override
  List<Object?> get props => [id, timestamp, open, high, low, close, volume];
}
class TimeSlot extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  const TimeSlot({required this.startTime, required this.endTime});
  @override
  List<Object?> get props => [startTime, endTime];
  String get displayText {
    final startFormat = _formatTime(startTime);
    final endFormat = _formatTime(endTime);
    return '$startFormat to $endFormat';
  }
  String _formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }
}
