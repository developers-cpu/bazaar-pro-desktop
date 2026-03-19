import '../../../domain/entities/user_credit_transaction/user_credit_transaction.dart';

class UserCreditTransactionModel extends UserCreditTransaction {
  const UserCreditTransactionModel({
    required super.id,
    required super.dateTime,
    required super.type,
    required super.amount,
    required super.balance,
    required super.comment,
  });
  factory UserCreditTransactionModel.fromJson(Map<String, dynamic> json) {
    return UserCreditTransactionModel(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      comment: json['comment'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'type': type,
      'amount': amount,
      'balance': balance,
      'comment': comment,
    };
  }
}