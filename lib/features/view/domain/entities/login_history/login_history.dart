import 'package:equatable/equatable.dart';

/// Login History entity
class LoginHistory extends Equatable {
  final String id;
  final int index;
  final DateTime loginTime;
  final String userName;
  final String userType;
  final String ipAddress;
  final String deviceId;

  const LoginHistory({
    required this.id,
    required this.index,
    required this.loginTime,
    required this.userName,
    required this.userType,
    required this.ipAddress,
    required this.deviceId,
  });

  @override
  List<Object?> get props => [
    id,
    index,
    loginTime,
    userName,
    userType,
    ipAddress,
    deviceId,
  ];

  LoginHistory copyWith({
    String? id,
    int? index,
    DateTime? loginTime,
    String? userName,
    String? userType,
    String? ipAddress,
    String? deviceId,
  }) {
    return LoginHistory(
      id: id ?? this.id,
      index: index ?? this.index,
      loginTime: loginTime ?? this.loginTime,
      userName: userName ?? this.userName,
      userType: userType ?? this.userType,
      ipAddress: ipAddress ?? this.ipAddress,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}