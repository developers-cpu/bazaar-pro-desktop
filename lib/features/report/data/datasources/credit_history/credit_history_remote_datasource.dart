import 'package:bazarpro/features/report/data/models/credit_history_model.dart';

abstract class CreditHistoryRemoteDataSource {
  Future<List<CreditHistoryModel>> getCreditHistory({
    String? type,
    String? search,
  });
}

class CreditHistoryRemoteDataSourceImpl
    implements CreditHistoryRemoteDataSource {
  @override
  Future<List<CreditHistoryModel>> getCreditHistory({
    String? type,
    String? search,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<CreditHistoryModel> mockData = List.generate(15, (index) {
      final isCredit = index % 2 == 0;
      final type = isCredit ? 'Credit' : 'Debit';
      final comment = isCredit ? 'Initial Credit' : 'Initial Debit';
      final amount = isCredit ? 500000.00 : -500000.00;

      double balance;
      if (index == 0)
        balance = 6000000.00;
      else if (index == 1)
        balance = 5500000.00;
      else if (index == 2)
        balance = 5000000.00;
      else if (index == 3)
        balance = 5500000.00;
      else if (index % 4 == 0)
        balance = 500000.00;
      else
        balance = 0.00;

      return CreditHistoryModel(
        id: index.toString(),
        userName: 'User $index',
        type: type,
        comment: comment,
        amount: index == 3 ? 5500000.00 : amount,
        balance: balance,
        dateTime: DateTime(2025, 11, 4, 13, 25, 35),
        parentUserName: 'DEMO',
      );
    });
    return mockData.where((item) {
      if (type != null &&
          type.isNotEmpty &&
          item.type.toLowerCase() != type.toLowerCase()) {
        return false;
      }
      if (search != null && search.isNotEmpty) {
        return item.userName.toLowerCase() == search.toLowerCase();
      }
      return true;
    }).toList();
  }
}
