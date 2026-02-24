import 'package:dio/dio.dart';
import '../../models/rejected_trade/rejected_trade_model.dart';

abstract class RejectedTradeRemoteDataSource {
  Future<List<RejectedTradeModel>> getRejectedTrades();
  Future<List<RejectedTradeModel>> getRejectedTradesWithFilters({
    String? userType,
    String? user,
    String? exchange,
    String? symbol,
  });
  Future<List<String>> getUserTypes();
  Future<List<String>> getUsers();
  Future<List<String>> getExchanges();
  Future<List<String>> getSymbols();
  Future<String> exportToPdf(List<RejectedTradeModel> trades);
  Future<String> exportToExcel(List<RejectedTradeModel> trades);
}

class RejectedTradeRemoteDataSourceImpl
    implements RejectedTradeRemoteDataSource {
  final Dio dio;
  RejectedTradeRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<RejectedTradeModel>> getRejectedTrades() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockRejectedTrades();
    } catch (e) {
      throw Exception('Failed to fetch rejected trades: $e');
    }
  }

  @override
  Future<List<RejectedTradeModel>> getRejectedTradesWithFilters({
    String? userType,
    String? user,
    String? exchange,
    String? symbol,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final allTrades = await getRejectedTrades();
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
      throw Exception('Failed to fetch filtered rejected trades: $e');
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
  Future<String> exportToPdf(List<RejectedTradeModel> trades) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'rejected_trades_${DateTime.now().millisecondsSinceEpoch}.pdf';
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  @override
  Future<String> exportToExcel(List<RejectedTradeModel> trades) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'rejected_trades_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    } catch (e) {
      throw Exception('Failed to export Excel: $e');
    }
  }

  List<RejectedTradeModel> _generateMockRejectedTrades() {
    final List<RejectedTradeModel> trades = [];
    final users = ['PATIL', 'DEMO4'];
    final parentUsers = ['DEMO', 'DEMO49', 'DEMO12'];
    final buySellTypes = [
      'SELL - SL Market',
      'BUY - SL Add Trade',
      'SELL - SL Add Trade',
      'BUY - SL Exit Market',
      'SELL - L Close Position',
      'BUY - SL Close Position',
      'SELL - SL Close Position',
      'SELL - SL Exit Market',
      'SELL - L Market',
      'SELL - L Add Trade',
      'SELL - L Exit Market',
      'BUY - L Close Position',
      'BUY - L Exit Market',
      'BUY - L Add Trade',
      'BUY - L Market',
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
    final baseDate = DateTime(2025, 11, 22, 15, 6, 34);
    final deviceId = 'E621E1F8-C36C-495A-93FC-0C247A3E6E5F';
    for (int i = 0; i < 50; i++) {
      trades.add(
        RejectedTradeModel(
          id: 'rejected_trade_$i',
          userName: users[i % users.length],
          parentUser: parentUsers[i % parentUsers.length],
          exchange: 'MCX',
          symbol: 'GOLD05DEC',
          orderDateTime: baseDate,
          buySell: buySellTypes[i % buySellTypes.length],
          qty: quantities[i % quantities.length],
          lot: 1.00,
          type: 'Rejected',
          pl: 36200.00,
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
