import 'package:bazarpro/features/users/data/models/user_trades/user_trade_model.dart';
import '../../../domain/entities/user_trades/user_trades_metadata.dart';
abstract class UserTradesDataSource {
  Future<List<UserTradeModel>> getUserTrades(String userId);
  Future<UserTradesMetadata> getUserTradesMetadata();
}
class UserTradesDataSourceImpl implements UserTradesDataSource {
  @override
  Future<List<UserTradeModel>> getUserTrades(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      UserTradeModel(
        id: '1',
        userName: 'User1',
        parentUser: 'Admin',
        exchange: 'NSE',
        symbol: 'NIFTY',
        buySell: 'BUY',
        tradeType: 'Intraday',
        quantity: 50.0,
        lot: 1.0,
        profitLoss: 1500.0,
        validity: 'DAY',
        tradePrice: 18000.0,
        brokerage: 20.0,
        netPrice: 18020.0,
        orderTime: DateTime.now().subtract(const Duration(minutes: 30)),
        executionTime: DateTime.now().subtract(const Duration(minutes: 29)),
        requestPrice: 18000.0,
        orderDuration: '00:01:00',
      ),
      UserTradeModel(
        id: '2',
        userName: 'User1',
        parentUser: 'Admin',
        exchange: 'MCX',
        symbol: 'CRUDEOIL',
        buySell: 'SELL',
        tradeType: 'Market',
        quantity: 100.0,
        lot: 1.0,
        profitLoss: -500.0,
        validity: 'DAY',
        tradePrice: 6500.0,
        brokerage: 50.0,
        netPrice: 6450.0,
        orderTime: DateTime.now().subtract(const Duration(hours: 2)),
        executionTime: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 59),
        ),
        requestPrice: 6500.0,
        orderDuration: '00:01:00',
      ),
      UserTradeModel(
        id: '3',
        userName: 'User2',
        parentUser: 'Admin',
        exchange: 'BSE',
        symbol: 'SENSEX',
        buySell: 'BUY',
        tradeType: 'Intraday',
        quantity: 25.0,
        lot: 1.0,
        profitLoss: 2000.0,
        validity: 'DAY',
        tradePrice: 60000.0,
        brokerage: 100.0,
        netPrice: 60100.0,
        orderTime: DateTime.now().subtract(const Duration(days: 1)),
        executionTime: DateTime.now().subtract(
          const Duration(days: 1, minutes: 5),
        ),
        requestPrice: 60000.0,
        orderDuration: '00:05:00',
      ),
    ];
  }
  @override
  Future<UserTradesMetadata> getUserTradesMetadata() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const UserTradesMetadata(
      exchanges: ['NSE', 'MCX', 'BSE'],
      symbols: ['NIFTY', 'BANKNIFTY', 'CRUDEOIL', 'GOLD', 'SILVER'],
      statuses: [
        'All',
        'Market',
        'Intraday',
        'Settled',
        'Pending to Success',
        'Super Admin',
      ],
    );
  }
}
