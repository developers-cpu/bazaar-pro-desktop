import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/trade_log_model.dart';

abstract class TradeLogRemoteDataSource {
  Future<Either<Failure, List<TradeLogModel>>> getTradeLogs({
    String? dateRange,
    String? user,
    String? exchange,
    String? symbol,
  });
}

class TradeLogRemoteDataSourceImpl implements TradeLogRemoteDataSource {
  @override
  Future<Either<Failure, List<TradeLogModel>>> getTradeLogs({
    String? dateRange,
    String? user,
    String? exchange,
    String? symbol,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<TradeLogModel> mockData = [
      TradeLogModel(
        id: '1',
        userName: 'DEMO',
        exchange: 'NSE',
        symbol: 'CRUDEOIL 22JULA',
        orderUpdateType: 'Traded',
        userType: 'Client',
        oldQty: 10,
        qty: 10,
        oldPrice: 7600.0,
        price: 7600.0,
        updateTime: DateTime.now().subtract(const Duration(minutes: 5)),
        orderDateTime: DateTime.now().subtract(const Duration(minutes: 6)),
        modifyBy: 'Admin',
      ),
      TradeLogModel(
        id: '2',
        userName: 'DEMO',
        exchange: 'NSE',
        symbol: 'BANKNIFTY 22JULA',
        orderUpdateType: 'Cancelled',
        userType: 'Client',
        oldQty: 25,
        qty: 0,
        oldPrice: 35000.0,
        price: 0.0,
        updateTime: DateTime.now().subtract(const Duration(minutes: 15)),
        orderDateTime: DateTime.now().subtract(const Duration(minutes: 20)),
        modifyBy: 'User',
      ),
      TradeLogModel(
        id: '3',
        userName: 'TEST_USER',
        exchange: 'MCX',
        symbol: 'GOLD 22JULA',
        orderUpdateType: 'Modified',
        userType: 'Master',
        oldQty: 1,
        qty: 2,
        oldPrice: 50000.0,
        price: 50050.0,
        updateTime: DateTime.now().subtract(const Duration(hours: 1)),
        orderDateTime: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 5),
        ),
        modifyBy: 'System',
      ),
    ];

    
    var filtered = mockData;
    if (user != null && user.isNotEmpty) {
      filtered = filtered.where((e) => e.userName == user).toList();
    }
    if (exchange != null && exchange.isNotEmpty) {
      filtered = filtered.where((e) => e.exchange == exchange).toList();
    }
    if (symbol != null && symbol.isNotEmpty) {
      filtered = filtered.where((e) => e.symbol == symbol).toList();
    }

    return Right(filtered);
  }
}
