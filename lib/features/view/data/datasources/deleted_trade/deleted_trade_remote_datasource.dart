import 'package:dio/dio.dart';
import '../../models/deleted_trade/deleted_trade_model.dart';

abstract class DeletedTradeRemoteDataSource {
  Future<List<DeletedTradeModel>> getDeletedTrades();
  Future<List<DeletedTradeModel>> getDeletedTradesWithFilters({
    String? userType,
    String? user,
    String? exchange,
    String? symbol,
  });
  Future<List<String>> getUserTypes();
  Future<List<String>> getUsers();
  Future<List<String>> getExchanges();
  Future<List<String>> getSymbols();
  Future<String> exportToPdf(List<DeletedTradeModel> trades);
  Future<String> exportToExcel(List<DeletedTradeModel> trades);
}

class DeletedTradeRemoteDataSourceImpl implements DeletedTradeRemoteDataSource {
  final Dio dio;
  DeletedTradeRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<DeletedTradeModel>> getDeletedTrades() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockDeletedTrades();
    } catch (e) {
      throw Exception('Failed to fetch deleted trades: $e');
    }
  }

  @override
  Future<List<DeletedTradeModel>> getDeletedTradesWithFilters({
    String? userType,
    String? user,
    String? exchange,
    String? symbol,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final allTrades = await getDeletedTrades();
      return allTrades.where((trade) {
        bool matches = true;
        if (user != null && user.isNotEmpty) {
          matches = matches && trade.userName == user;
        }
        if (exchange != null && exchange.isNotEmpty) {
          matches = matches && trade.exchange == exchange;
        }
        if (symbol != null && symbol.isNotEmpty) {
          matches = matches && trade.symbol == symbol;
        }
        return matches;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch filtered deleted trades: $e');
    }
  }

  @override
  Future<List<String>> getUserTypes() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['Master', 'Client'];
    } catch (e) {
      throw Exception('Failed to fetch user types: $e');
    }
  }

  @override
  Future<List<String>> getUsers() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['PATIL', 'DEMO4', 'DEMO', 'DEMO49', 'DEMO12'];
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  @override
  Future<List<String>> getExchanges() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['NSE', 'MCX', 'CE/PE', 'OTHERS'];
    } catch (e) {
      throw Exception('Failed to fetch exchanges: $e');
    }
  }

  @override
  Future<List<String>> getSymbols() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['GOLD05DEC', 'SILVER05DEC', 'CRUDEOIL20OCT', 'NIFTY25N042555OCE'];
    } catch (e) {
      throw Exception('Failed to fetch symbols: $e');
    }
  }

  @override
  Future<String> exportToPdf(List<DeletedTradeModel> trades) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'deleted_trades_${DateTime.now().millisecondsSinceEpoch}.pdf';
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  @override
  Future<String> exportToExcel(List<DeletedTradeModel> trades) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'deleted_trades_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    } catch (e) {
      throw Exception('Failed to export Excel: $e');
    }
  }

  List<DeletedTradeModel> _generateMockDeletedTrades() {
    final List<DeletedTradeModel> trades = [];
    final users = ['PATIL', 'DEMO4'];
    final parentUsers = ['DEMO', 'DEMO49', 'DEMO12'];
    final buySellTypes = [
      'SELL - SL Market',
      'BUY - SL Add Trade',
      'SELL - SL Add Trade',
      'BUY - SL Exit Market',
      'SELL - L Close Position',
      'BUY - SL Close Position',
      'SELL - L Market',
      'SELL - L Add Trade',
      'SELL - L Exit Market',
      'BUY - L Close Position',
      'BUY - L Exit Market',
      'BUY - L Add Trade',
      'BUY - L Market',
      'BUY - SL Close Position',
      'SELL - SL Close Position',
    ];
    final quantities = [
      -500.0,
      1000000.0,
      -500.0,
      100.0,
      -500.0,
      100.0,
      -500.0,
      100.0,
      1000000.0,
      -500.0,
      100.0,
      -500.0,
      -500.0,
      -500.0,
      100.0,
    ];
    final pls = [
      36200.0,
      36200.0,
      36200.0,
      36200.0,
      36200.0,
      36200.0,
      36200.0,
      36200.0,
      36200.0,
      36200.0,
      36200.0,
      36200.0,
      36200.0,
      36200.0,
      36200.0,
    ];
    final baseDate = DateTime(2025, 11, 22, 15, 6, 34);
    final deviceId = 'E621E1F8-C36C-495A-93FC-0C247A3E6E5F';
    for (int i = 0; i < 50; i++) {
      trades.add(
        DeletedTradeModel(
          id: 'deleted_trade_$i',
          userName: users[i % users.length],
          parentUser: parentUsers[i % parentUsers.length],
          exchange: 'MCX',
          symbol: 'GOLD05DEC',
          orderDateTime: baseDate,
          buySell: buySellTypes[i % buySellTypes.length],
          qty: quantities[i % quantities.length],
          lot: 1.00,
          type: 'Deleted',
          pl: pls[i % pls.length],
          tradePrice: 124191.00,
          brokerage: 0.00,
          ratePrice: 0.00,
          executionDateTime: baseDate,
          deviceId: deviceId,
          city: 'Abu dabhi',
          device: 'IOS',
          ipAddress: '192.0.2.1',
        ),
      );
    }
    return trades;
  }
}
