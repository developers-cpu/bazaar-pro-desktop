import 'package:dio/dio.dart';
import '../../models/pending_orders/pending_order_model.dart';
abstract class PendingOrdersRemoteDataSource {
  Future<List<PendingOrderModel>> getPendingOrders();
  Future<List<PendingOrderModel>> getPendingOrdersWithFilters({
    String? client,
    String? exchange,
    String? symbol,
    String? type,
  });
  Future<List<String>> getClients();
  Future<List<String>> getExchanges();
  Future<List<String>> getSymbols();
}
class PendingOrdersRemoteDataSourceImpl
    implements PendingOrdersRemoteDataSource {
  final Dio dio;
  PendingOrdersRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<PendingOrderModel>> getPendingOrders() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateDummyOrders();
    } catch (e) {
      throw Exception('Failed to fetch pending orders: $e');
    }
  }
  @override
  Future<List<PendingOrderModel>> getPendingOrdersWithFilters({
    String? client,
    String? exchange,
    String? symbol,
    String? type,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final allOrders = _generateDummyOrders();
      return allOrders.where((order) {
        if (client != null && client.isNotEmpty && order.userId != client) {
          return false;
        }
        if (exchange != null &&
            exchange.isNotEmpty &&
            order.exchange != exchange) {
          return false;
        }
        if (symbol != null && symbol.isNotEmpty && order.symbol != symbol) {
          return false;
        }
        if (type != null && type.isNotEmpty && type != 'All') {
          if (!order.buySell.toLowerCase().contains(type.toLowerCase())) {
            return false;
          }
        }
        return true;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch filtered pending orders: $e');
    }
  }
  @override
  Future<List<String>> getClients() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['PATIL', 'DEMO', 'DEMO4', 'DEMO12', 'DEMO49'];
    } catch (e) {
      throw Exception('Failed to fetch clients: $e');
    }
  }
  @override
  Future<List<String>> getExchanges() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return [
        'NSE',
        'MCX',
        'CE/PE',
        'OTHERS',
        'COMEX',
        'CRYPTO',
        'GIFT',
        'FOREX',
      ];
    } catch (e) {
      throw Exception('Failed to fetch exchanges: $e');
    }
  }
  @override
  Future<List<String>> getSymbols() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return [
        'GOLD05DEC',
        'SILVER05DEC',
        'CRUDE05DEC',
        'GIFTNIFTY Oct 28',
        'NIFTY Oct 28',
        'BANKNIFTY Oct 28',
        'MINI GOLDMINI Dec 05',
        'MINI SILVERMINI Dec 05',
        'DOW Dec 19',
        'NASDAQ Dec 19',
        'S & P Dec 19',
      ];
    } catch (e) {
      throw Exception('Failed to fetch symbols: $e');
    }
  }
  List<PendingOrderModel> _generateDummyOrders() {
    final List<String> users = ['PATIL', 'DEMO4', 'DEMO49', 'DEMO12', 'DEMO'];
    final List<String> uplines = ['DEMO', 'DEMO49', 'DEMO12'];
    final List<String> exchanges = ['MCX', 'NSE', 'CE/PE'];
    final List<String> symbols = ['GOLD05DEC', 'SILVER05DEC', 'CRUDE05DEC'];
    final List<String> buySellTypes = [
      'SELL - SL Market',
      'BUY - SL Add Trade',
      'SELL - SL Add Trade',
      'BUY - SL Exit Market',
      'SELL - L Close Position',
      'BUY - SL Close Position',
      'SELL - SL Close Position',
      'BUY - L Close Position',
      'SELL - L Market',
      'BUY - L Market',
      'SELL - L Add Trade',
      'BUY - L Add Trade',
      'SELL - L Exit Market',
      'BUY - L Exit Market',
    ];
    final List<PendingOrderModel> orders = [];
    for (int i = 0; i < 50; i++) {
      final buySell = buySellTypes[i % buySellTypes.length];
      final qty = buySell.startsWith('BUY')
          ? [100.0, 1000000.0, 100000.0][i % 3]
          : -500.0;
      orders.add(
        PendingOrderModel(
          id: 'order_$i',
          userId: users[i % users.length],
          upline: uplines[i % uplines.length],
          exchange: exchanges[i % exchanges.length],
          symbol: symbols[i % symbols.length],
          buySell: buySell,
          qty: qty,
          lot: 1.00,
          triggerPrice: buySell.startsWith('SELL') ? -256 : 124191.00,
          orderDateTime: DateTime(2025, 11, 22, 3, 6, 34),
          modifyOrderDateTime: DateTime(2025, 11, 4, 1, 25, 35),
          orderType: 'Market',
          cmp: 36200.00,
          rPrice: 36200.00,
          deviceId: 'E621E1F8-C36C-495A-93FC-0C247A3E6E5F',
          ipAddress: '192.0.2.1',
        ),
      );
    }
    return orders;
  }
}
