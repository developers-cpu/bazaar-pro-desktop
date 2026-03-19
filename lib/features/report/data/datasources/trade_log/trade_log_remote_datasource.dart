import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../models/trade_log_model.dart';

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
    final List<TradeLogModel> mockData = _generateDummyTradeLogs();

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

  List<TradeLogModel> _generateDummyTradeLogs() {
    final List<String> userNames = ['PATIL', 'DEMO4', 'ADMIN', 'MASTER', 'USER123'];
    final List<String> exchanges = ['NSE', 'MCX', 'NFO', 'BTX'];
    final List<String> orderTypes = ['Limit', 'Market', 'SL', 'SL-M'];

    final List<TradeLogModel> list = [];
    final DateTime now = DateTime.now();

    for (int i = 1; i <= 35; i++) {
      list.add(
        TradeLogModel(
          id: i.toString(),
          userName: userNames[i % userNames.length],
          exchange: exchanges[i % exchanges.length],
          symbol: 'GOLD05DEC-${i + 100}',
          orderUpdateType: orderTypes[i % orderTypes.length],
          userType: i % 3 == 0 ? 'Master' : 'Client',
          oldQty: (i * 100).toDouble(),
          qty: (i * 100).toDouble(),
          oldPrice: 35000.0 + (i * 10),
          price: 35000.0 + (i * 10),
          updateTime: now.subtract(Duration(minutes: i * 2)),
          orderDateTime: now.subtract(Duration(minutes: i * 2 + 1)),
          modifyBy: 'DEMO${i.toString().padLeft(2, '0')}',
        ),
      );
    }
    return list;
  }
}