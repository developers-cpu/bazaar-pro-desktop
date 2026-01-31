import '../models/trade_log_model.dart';

abstract class TradeLogRemoteDataSource {
  Future<List<TradeLogModel>> getTradeLogs({
    String? dateRange,
    String? user,
    String? exchange,
    String? symbol,
  });
}

class TradeLogRemoteDataSourceImpl implements TradeLogRemoteDataSource {
  @override
  Future<List<TradeLogModel>> getTradeLogs({
    String? dateRange,
    String? user,
    String? exchange,
    String? symbol,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      TradeLogModel(
        id: '1',
        userName: 'PATIL',
        exchange: 'MCX',
        symbol: 'GOLD05DEC',
        orderUpdateType: 'Limit',
        userType: 'Limit',
        oldQty: -500.00,
        qty: -500.00,
        oldPrice: 36200.00,
        price: 124191.00,
        updateTime: DateTime.now(),
        orderDateTime: DateTime.now(),
        modifyBy: 'DEMO02',
      ),
      TradeLogModel(
        id: '2',
        userName: 'DEMO4',
        exchange: 'NSE',
        symbol: 'GOLD05DEC',
        orderUpdateType: 'Limit',
        userType: 'Limit',
        oldQty: 1000000,
        qty: 1000000,
        oldPrice: 36200.00,
        price: 124191.00,
        updateTime: DateTime.now(),
        orderDateTime: DateTime.now(),
        modifyBy: 'DEMO32',
      ),
      TradeLogModel(
        id: '3',
        userName: 'PATIL',
        exchange: 'MCX',
        symbol: 'GOLD05DEC',
        orderUpdateType: 'Limit',
        userType: 'Limit',
        oldQty: -500.00,
        qty: -500.00,
        oldPrice: 36200.00,
        price: -256,
        updateTime: DateTime.now(),
        orderDateTime: DateTime.now(),
        modifyBy: 'DEMO01',
      ),
    ];
  }
}
