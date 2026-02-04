import 'package:bazarpro/features/users/data/models/user_pending_order/user_pending_order_metadata_model.dart';
import 'package:bazarpro/features/users/data/models/user_pending_order/user_pending_order_model.dart';
abstract class UserPendingOrderDataSource {
  Future<List<UserPendingOrderModel>> getUserPendingOrders(String userId);
  Future<UserPendingOrderMetadataModel> getPendingOrderMetadata();
}
class UserPendingOrderDataSourceImpl implements UserPendingOrderDataSource {
  @override
  Future<List<UserPendingOrderModel>> getUserPendingOrders(
    String userId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      UserPendingOrderModel(
        id: '1',
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        symbol: 'SGX GIFTNIFTY Oct 28',
        exchange: 'NSE',
        type: 'Buy Limit',
        lot: '50',
        price: 19500.0,
        status: 'Pending',
      ),
      UserPendingOrderModel(
        id: '2',
        time: DateTime.now().subtract(const Duration(minutes: 15)),
        symbol: 'NSE BANKNIFTY Oct 28',
        exchange: 'NSE',
        type: 'Sell Stop',
        lot: '25',
        price: 44200.0,
        status: 'Pending',
      ),
    ];
  }
  @override
  Future<UserPendingOrderMetadataModel> getPendingOrderMetadata() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserPendingOrderMetadataModel(
      exchanges: ['NSE', 'MCX', 'BSE'],
      symbols: ['NIFTY', 'BANKNIFTY', 'CRUDEOIL'],
      orderTypes: ['Limit', 'Market', 'Stop Loss'],
    );
  }
}
