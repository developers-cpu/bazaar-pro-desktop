import 'package:equatable/equatable.dart';
class MarketTimingEntity extends Equatable {
  final String status;
  final bool isOpen;
  final List<TimingSlot> timings;
  const MarketTimingEntity({
    required this.status,
    required this.isOpen,
    required this.timings,
  });
  @override
  List<Object?> get props => [status, isOpen, timings];
}
class TimingSlot extends Equatable {
  final String start;
  final String end;
  const TimingSlot({required this.start, required this.end});
  @override
  List<Object?> get props => [start, end];
}
