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

    final List<CreditHistoryModel> mockData = [
      CreditHistoryModel(
        id: '1',
        userName: 'User 1',
        type: 'Credit',
        comment: 'Deposit',
        amount: 500000.00,
        balance: 1500000.00,
        dateTime: DateTime.now(),
        parentUserName: 'DEMO',
      ),
      CreditHistoryModel(
        id: '2',
        userName: 'User 2',
        type: 'Debit',
        comment: 'Withdrawal',
        amount: -20000.00,
        balance: 480000.00,
        dateTime: DateTime.now().subtract(const Duration(hours: 2)),
        parentUserName: 'DEMO',
      ),
      CreditHistoryModel(
        id: '3',
        userName: 'User 3',
        type: 'Credit',
        comment: 'Bonus',
        amount: 15000.00,
        balance: 15000.00,
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        parentUserName: 'DEMO',
      ),
      CreditHistoryModel(
        id: '4',
        userName: 'User 4',
        type: 'Debit',
        comment: 'Correction',
        amount: 0.00,
        balance: 0.00,
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        parentUserName: 'DEMO',
      ),
      CreditHistoryModel(
        id: '5',
        userName: 'User 5',
        type: 'Credit',
        comment: 'Transfer',
        amount: 100000.00,
        balance: 100000.00,
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        parentUserName: 'DEMO',
      ),
      CreditHistoryModel(
        id: '6',
        userName: 'DEMO',
        type: 'Credit',
        comment: 'Self funding',
        amount: 1000000.00,
        balance: 5000000.00,
        dateTime: DateTime.now(),
        parentUserName: 'ADMIN',
      ),
    ];

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
