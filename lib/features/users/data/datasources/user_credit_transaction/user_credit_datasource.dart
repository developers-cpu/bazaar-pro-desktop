import 'package:bazarpro/features/users/data/models/user_credit_transaction/user_credit_model.dart';

abstract class UserCreditDataSource {
  Future<List<UserCreditTransactionModel>> getUserCreditHistory(String userId);
}

class UserCreditDataSourceImpl implements UserCreditDataSource {
  @override
  Future<List<UserCreditTransactionModel>> getUserCreditHistory(
    String userId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(
      15,
      (index) => UserCreditTransactionModel(
        id: 'credit_${index}',
        dateTime: DateTime.now().subtract(Duration(days: index)),
        type: index % 2 == 0 ? 'Credit' : 'Debit',
        amount: (index + 1) * 1000.0,
        balance: 50000.0 + (index * 500),
        comment: index % 2 == 0 ? 'Deposit via UPI' : 'Withdrawal Request',
      ),
    );
  }
}
