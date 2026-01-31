import '../../../domain/entities/login_history/login_history.dart';

class LoginHistoryModel extends LoginHistory {
  const LoginHistoryModel({
    required super.id,
    required super.index,
    required super.loginTime,
    required super.userName,
    required super.userType,
    required super.ipAddress,
    required super.deviceId,
  });

  factory LoginHistoryModel.fromJson(Map<String, dynamic> json) {
    return LoginHistoryModel(
      id: json['id']?.toString() ?? '',
      index: json['index'] ?? 0,
      loginTime: json['loginTime'] != null
          ? DateTime.parse(json['loginTime'])
          : DateTime.now(),
      userName: json['userName'] ?? json['user_name'] ?? '',
      userType: json['userType'] ?? json['user_type'] ?? '',
      ipAddress: json['ipAddress'] ?? json['ip_address'] ?? '',
      deviceId: json['deviceId'] ?? json['device_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'loginTime': loginTime.toIso8601String(),
      'userName': userName,
      'userType': userType,
      'ipAddress': ipAddress,
      'deviceId': deviceId,
    };
  }

  factory LoginHistoryModel.fromEntity(LoginHistory history) {
    return LoginHistoryModel(
      id: history.id,
      index: history.index,
      loginTime: history.loginTime,
      userName: history.userName,
      userType: history.userType,
      ipAddress: history.ipAddress,
      deviceId: history.deviceId,
    );
  }
}