import '../../domain/entities/credit_history.dart';

class CreditHistoryModel extends CreditHistory {
  const CreditHistoryModel({
    required super.id,
    required super.userName,
    required super.parentUserName,
    required super.dateTime,
    required super.type,
    required super.amount,
    required super.balance,
    required super.comment,
  });

  factory CreditHistoryModel.fromJson(Map<String, dynamic> json) {
    return CreditHistoryModel(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      parentUserName: json['parentUserName'] ?? '',
      dateTime: DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now(),
      type: json['type'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] ?? '',
    );
  }
}
