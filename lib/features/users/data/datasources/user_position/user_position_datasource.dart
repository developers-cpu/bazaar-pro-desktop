import 'package:bazarpro/features/users/data/models/user_position/user_position_model.dart';

abstract class UserPositionDataSource {
  Future<List<UserPositionModel>> getUserPositions(String userId);
}

class UserPositionDataSourceImpl implements UserPositionDataSource {
  @override
  Future<List<UserPositionModel>> getUserPositions(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      const UserPositionModel(
        exchange: 'NSE',
        symbol: 'NIFTY',
        buyQty: 50.0,
        sellQty: 0.0,
        netQty: 50.0,
        netAp: 18000.0,
        cmp: 18100.0,
        m2m: 5000.0,
        lot: 50.0,
      ),
      const UserPositionModel(
        exchange: 'MCX',
        symbol: 'GOLD',
        buyQty: 0.0,
        sellQty: 10.0,
        netQty: -10.0,
        netAp: 50000.0,
        cmp: 49500.0,
        m2m: 5000.0,
        lot: 10.0,
      ),
    ];
  }
}
