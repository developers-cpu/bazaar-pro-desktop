import '../../domain/entities/market_timing_entity.dart';
class MarketTimingModel extends MarketTimingEntity {
  const MarketTimingModel({
    required String status,
    required bool isOpen,
    required List<TimingSlotModel> timings,
  }) : super(status: status, isOpen: isOpen, timings: timings);
  factory MarketTimingModel.fromJson(Map<String, dynamic> json) {
    return MarketTimingModel(
      status: json['status'],
      isOpen: json['isOpen'],
      timings: (json['timings'] as List)
          .map((e) => TimingSlotModel.fromJson(e))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'isOpen': isOpen,
      'timings': timings.map((e) => (e as TimingSlotModel).toJson()).toList(),
    };
  }
}
class TimingSlotModel extends TimingSlot {
  const TimingSlotModel({required String start, required String end})
    : super(start: start, end: end);
  factory TimingSlotModel.fromJson(Map<String, dynamic> json) {
    return TimingSlotModel(start: json['start'], end: json['end']);
  }
  Map<String, dynamic> toJson() {
    return {'start': start, 'end': end};
  }
}
