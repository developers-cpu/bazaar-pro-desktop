import 'package:equatable/equatable.dart';
class UserIntradaySquareOff extends Equatable {
  final String id;
  final String exchange;
  final String time;
  final bool isEnabled;
  const UserIntradaySquareOff({
    required this.id,
    required this.exchange,
    required this.time,
    required this.isEnabled,
  });
  @override
  List<Object?> get props => [id, exchange, time, isEnabled];
}
