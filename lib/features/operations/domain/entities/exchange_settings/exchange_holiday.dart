import 'package:equatable/equatable.dart';

class ExchangeHoliday extends Equatable {
  final String id;
  final String date;
  final String remark;
  final String exchange;

  const ExchangeHoliday({
    required this.id,
    required this.date,
    required this.remark,
    required this.exchange,
  });

  @override
  List<Object?> get props => [id, date, remark, exchange];
}
