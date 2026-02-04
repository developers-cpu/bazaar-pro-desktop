import 'package:equatable/equatable.dart';
class CreditHistory extends Equatable {
  final String id;
  final String userName;
  final String parentUserName;
  final DateTime dateTime;
  final String type;
  final double amount;
  final double balance;
  final String comment;
  const CreditHistory({
    required this.id,
    required this.userName,
    required this.parentUserName,
    required this.dateTime,
    required this.type,
    required this.amount,
    required this.balance,
    required this.comment,
  });
  @override
  List<Object?> get props => [
    id,
    userName,
    parentUserName,
    dateTime,
    type,
    amount,
    balance,
    comment,
  ];
}
