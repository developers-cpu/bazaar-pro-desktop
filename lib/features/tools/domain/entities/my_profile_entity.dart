import 'package:equatable/equatable.dart';

class MyProfileEntity extends Equatable {
  final String userName;
  final String name;
  final double credit;
  final String remark;
  final String leverage;
  final double creditLimit;
  final String mobile;
  final Map<String, dynamic> plSharing;
  final Map<String, dynamic> brkSharing;
  final List<String> exchanges;
  const MyProfileEntity({
    required this.userName,
    required this.name,
    required this.credit,
    required this.remark,
    required this.leverage,
    required this.creditLimit,
    required this.mobile,
    required this.plSharing,
    required this.brkSharing,
    required this.exchanges,
  });
  @override
  List<Object?> get props => [
    userName,
    name,
    credit,
    remark,
    leverage,
    creditLimit,
    mobile,
    plSharing,
    brkSharing,
    exchanges,
  ];
}
