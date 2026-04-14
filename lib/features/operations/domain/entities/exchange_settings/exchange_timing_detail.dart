import 'package:equatable/equatable.dart';

class ExchangeTimingDetail extends Equatable {
  final String id;
  final List<String> days;
  final String startTime;
  final String endTime;
  final String remark;
  final String exchange;

  const ExchangeTimingDetail({
    required this.id,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.remark,
    required this.exchange,
  });

  @override
  List<Object?> get props => [id, days, startTime, endTime, remark, exchange];
}
