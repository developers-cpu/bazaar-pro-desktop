import '../../domain/entities/user_script_position_tracking.dart';

class UserScriptPositionTrackingModel extends UserScriptPositionTracking {
  const UserScriptPositionTrackingModel({
    required super.id,
    required super.positionDate,
    required super.userName,
    required super.symbol,
    required super.position,
    required super.openAPrice,
    required super.days,
  });
  factory UserScriptPositionTrackingModel.fromJson(Map<String, dynamic> json) {
    return UserScriptPositionTrackingModel(
      id: json['id'] as String,
      positionDate: json['positionDate'] as String,
      userName: json['userName'] as String,
      symbol: json['symbol'] as String,
      position: json['position'] as String,
      openAPrice: (json['openAPrice'] as num).toDouble(),
      days: json['days'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'positionDate': positionDate,
      'userName': userName,
      'symbol': symbol,
      'position': position,
      'openAPrice': openAPrice,
      'days': days,
    };
  }
}
