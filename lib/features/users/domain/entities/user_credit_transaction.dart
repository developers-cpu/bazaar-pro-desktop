import 'package:equatable/equatable.dart';

class UserCreditTransaction extends Equatable {
  final String id;
  final DateTime dateTime;
  final String type; // 'Credit' or 'Debit'
  final double amount;
  final double balance;
  final String comment;

  const UserCreditTransaction({
    required this.id,
    required this.dateTime,
    required this.type,
    required this.amount,
    required this.balance,
    required this.comment,
  });

  @override
  List<Object?> get props => [id, dateTime, type, amount, balance, comment];
}
