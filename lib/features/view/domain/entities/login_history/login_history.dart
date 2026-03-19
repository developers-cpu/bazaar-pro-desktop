import 'package:equatable/equatable.dart';

class LoginHistory extends Equatable {
  final String id;
  final int index;
  final DateTime loginTime;
  final DateTime logoutTime;
  final String userName;
  final String userType;
  final String ipAddress;
  final String deviceId;
  final String device;
  final String city;
  const LoginHistory({
    required this.id,
    required this.index,
    required this.loginTime,
    required this.logoutTime,
    required this.userName,
    required this.userType,
    required this.ipAddress,
    required this.deviceId,
    required this.device,
    required this.city,
  });
  @override
  List<Object?> get props => [
    id,
    index,
    loginTime,
    logoutTime,
    userName,
    userType,
    ipAddress,
    deviceId,
    device,
    city,
  ];
  LoginHistory copyWith({
    String? id,
    int? index,
    DateTime? loginTime,
    DateTime? logoutTime,
    String? userName,
    String? userType,
    String? ipAddress,
    String? deviceId,
    String? device,
    String? city,
  }) {
    return LoginHistory(
      id: id ?? this.id,
      index: index ?? this.index,
      loginTime: loginTime ?? this.loginTime,
      logoutTime: logoutTime ?? this.logoutTime,
      userName: userName ?? this.userName,
      userType: userType ?? this.userType,
      ipAddress: ipAddress ?? this.ipAddress,
      deviceId: deviceId ?? this.deviceId,
      device: device ?? this.device,
      city: city ?? this.city,
    );
  }
}