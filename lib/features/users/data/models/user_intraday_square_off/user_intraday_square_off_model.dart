import '../../../domain/entities/user_intraday_square_off/user_intraday_square_off.dart';

class UserIntradaySquareOffModel extends UserIntradaySquareOff {
  const UserIntradaySquareOffModel({
    required super.id,
    required super.exchange,
    required super.time,
    required super.isEnabled,
  });
  factory UserIntradaySquareOffModel.fromJson(Map<String, dynamic> json) {
    return UserIntradaySquareOffModel(
      id: json['id'],
      exchange: json['exchange'],
      time: json['time'],
      isEnabled: json['isEnabled'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'time': time,
      'isEnabled': isEnabled,
    };
  }
}