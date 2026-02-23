import 'package:bazarpro/features/users/data/models/user_rejection_log/user_rejection_log_metadata_model.dart';
import 'package:bazarpro/features/users/data/models/user_rejection_log/user_rejection_log_model.dart';
abstract class UserRejectionLogDataSource {
  Future<List<UserRejectionLogModel>> getUserRejectionLogs(String userId);
  Future<UserRejectionLogMetadataModel> getRejectionLogMetadata();
}
class UserRejectionLogDataSourceImpl implements UserRejectionLogDataSource {
  @override
  Future<List<UserRejectionLogModel>> getUserRejectionLogs(
    String userId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      UserRejectionLogModel(
        id: '1',
        dateTime: DateTime.now().subtract(const Duration(minutes: 5)),
        status: 'Rejected',
        userName: 'AmanTest',
        exchange: 'NSE',
        symbol: 'NIFTY',
        type: 'Buy',
        qty: 50,
        price: 19500.0,
        comment: 'Margin shortfall',
      ),
      UserRejectionLogModel(
        id: '2',
        dateTime: DateTime.now().subtract(const Duration(hours: 1)),
        status: 'Rejected',
        userName: 'AmanTest',
        exchange: 'MCX',
        symbol: 'CRUDEOIL',
        type: 'Sell',
        qty: 10,
        price: 6500.0,
        comment: 'Limit Exceeded',
      ),
    ];
  }
  @override
  Future<UserRejectionLogMetadataModel> getRejectionLogMetadata() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserRejectionLogMetadataModel.mock();
  }
}
