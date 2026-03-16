import '../../models/users_bill_summary/users_bill_summary_model.dart';

abstract class UsersBillSummaryRemoteDataSource {
  Future<List<UsersBillSummaryModel>> getBillSummary(String userId);
  Future<List<String>> getUsers();
}

class UsersBillSummaryRemoteDataSourceImpl
    implements UsersBillSummaryRemoteDataSource {
  @override
  Future<List<UsersBillSummaryModel>> getBillSummary(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const UsersBillSummaryModel(
        puName: 'PATIL',
        uName: 'PATIL',
        netPL: -18872.50,
      ),
      const UsersBillSummaryModel(
        puName: 'PATIL',
        uName: 'PATIL',
        netPL: -18872.50,
      ),
      const UsersBillSummaryModel(
        puName: 'PATIL',
        uName: 'PATIL',
        netPL: -18872.50,
      ),
      const UsersBillSummaryModel(
        puName: 'DEMO4',
        uName: 'DEMO4',
        netPL: 21721.00,
      ),
      const UsersBillSummaryModel(
        puName: 'PATIL',
        uName: 'PATIL',
        netPL: -18872.50,
      ),
      const UsersBillSummaryModel(
        puName: 'PATIL',
        uName: 'PATIL',
        netPL: -18872.50,
      ),
      const UsersBillSummaryModel(
        puName: 'PATIL',
        uName: 'PATIL',
        netPL: 124191.00,
      ),
      const UsersBillSummaryModel(
        puName: 'PATIL',
        uName: 'PATIL',
        netPL: -18872.50,
      ),
      const UsersBillSummaryModel(
        puName: 'DEMO4',
        uName: 'DEMO4',
        netPL: 21721.00,
      ),
      const UsersBillSummaryModel(
        puName: 'PATIL',
        uName: 'PATIL',
        netPL: 124191.00,
      ),
      const UsersBillSummaryModel(
        puName: 'DEMO4',
        uName: 'DEMO4',
        netPL: 21721.00,
      ),
      const UsersBillSummaryModel(
        puName: 'PATIL',
        uName: 'PATIL',
        netPL: 124191.00,
      ),
      const UsersBillSummaryModel(
        puName: 'PATIL',
        uName: 'PATIL',
        netPL: 124191.00,
      ),
      const UsersBillSummaryModel(
        puName: 'PATIL',
        uName: 'PATIL',
        netPL: 124191.00,
      ),
    ];
  }

  @override
  Future<List<String>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ['User 1', 'User 2', 'User 3', 'User 4', 'User 5'];
  }
}
