import 'package:bazarpro/core/widget/table/table_export_service.dart';
import 'package:bazarpro/core/widget/table/view_data_table.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../models/trades/trade_model.dart';

abstract class TradesRemoteDataSource {
  Future<List<TradeModel>> getTrades();
  Future<List<TradeModel>> getTradesWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
    String? orderType,
  });
  Future<List<String>> getClients();
  Future<List<String>> getExchanges();
  Future<List<String>> getSymbols();
  Future<List<String>> getOrderTypes();
  Future<String> exportToPdf(List<TradeModel> trades);
  Future<String> exportToExcel(List<TradeModel> trades);
}

class TradesRemoteDataSourceImpl implements TradesRemoteDataSource {
  final Dio dio;
  TradesRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<TradeModel>> getTrades() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockTrades();
    } catch (e) {
      throw Exception('Failed to fetch trades: $e');
    }
  }

  @override
  Future<List<TradeModel>> getTradesWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
    String? orderType,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final allTrades = await getTrades();
      return allTrades.where((trade) {
        bool matches = true;
        if (startDate != null) {
          matches = matches && trade.orderDateTime.isAfter(startDate);
        }
        if (endDate != null) {
          matches =
              matches &&
              trade.orderDateTime.isBefore(
                endDate.add(const Duration(days: 1)),
              );
        }
        if (client != null && client.isNotEmpty) {
          matches = matches && trade.userName == client;
        }
        if (exchange != null && exchange.isNotEmpty && exchange != 'All') {
          matches = matches && trade.exchange == exchange;
        }
        if (symbol != null && symbol.isNotEmpty) {
          matches = matches && trade.symbol == symbol;
        }
        if (orderType != null && orderType.isNotEmpty && orderType != 'All') {
          matches =
              matches &&
              trade.buySell.toLowerCase().startsWith(orderType.toLowerCase());
        }
        return matches;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch filtered trades: $e');
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
      ];
    } catch (e) {
      throw Exception('Failed to fetch symbols: $e');
    }
  }

  @override
  Future<List<String>> getOrderTypes() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['All', 'Buy', 'Sell'];
    } catch (e) {
      throw Exception('Failed to fetch order types: $e');
    }
  }

  @override
  Future<String> exportToPdf(List<TradeModel> trades) async {
    const columns = [
      ViewTableColumn(id: 'userName', label: 'U.NAME', width: 100),
      ViewTableColumn(id: 'pUser', label: 'P USER', width: 90),
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 120),
      ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 150),
      ViewTableColumn(id: 'buySell', label: 'B/S', width: 180),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 80, isNumeric: true),
      ViewTableColumn(id: 'lot', label: 'LOT', width: 70, isNumeric: true),
      ViewTableColumn(id: 'orderType', label: 'TYPE', width: 80),
      ViewTableColumn(id: 'pl', label: 'P/L', width: 90, isNumeric: true),
      ViewTableColumn(
        id: 'triggerPrice',
        label: 'T.PRICE',
        width: 90,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'brokerage',
        label: 'BRK',
        width: 70,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'rPrice',
        label: 'R.PRICE',
        width: 90,
        isNumeric: true,
      ),
    ];
    final dtf = DateFormat('dd/MM/yy HH:mm');
    await TableExportService.exportAsPdf<TradeModel>(
      title: 'Trades',
      columns: columns,
      data: trades,
      cellValueExtractor: (t, col) {
        switch (col.id) {
          case 'userName':
            return t.userName;
          case 'pUser':
            return t.pUser;
          case 'exchange':
            return t.exchange;
          case 'symbol':
            return t.symbol;
          case 'orderDateTime':
            return dtf.format(t.orderDateTime);
          case 'buySell':
            return t.buySell;
          case 'qty':
            return t.qty.toStringAsFixed(2);
          case 'lot':
            return t.lot.toStringAsFixed(2);
          case 'orderType':
            return t.orderType;
          case 'pl':
            return t.pl.toStringAsFixed(2);
          case 'triggerPrice':
            return t.triggerPrice.toStringAsFixed(2);
          case 'brokerage':
            return t.brokerage.toStringAsFixed(2);
          case 'rPrice':
            return t.rPrice.toStringAsFixed(2);
          default:
            return '-';
        }
      },
    );
    return 'trades_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  @override
  Future<String> exportToExcel(List<TradeModel> trades) async {
    const columns = [
      ViewTableColumn(id: 'userName', label: 'U.NAME', width: 100),
      ViewTableColumn(id: 'pUser', label: 'P USER', width: 90),
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 120),
      ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 150),
      ViewTableColumn(id: 'buySell', label: 'B/S', width: 180),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 80, isNumeric: true),
      ViewTableColumn(id: 'lot', label: 'LOT', width: 70, isNumeric: true),
      ViewTableColumn(id: 'orderType', label: 'TYPE', width: 80),
      ViewTableColumn(id: 'pl', label: 'P/L', width: 90, isNumeric: true),
      ViewTableColumn(
        id: 'triggerPrice',
        label: 'T.PRICE',
        width: 90,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'brokerage',
        label: 'BRK',
        width: 70,
        isNumeric: true,
      ),
      ViewTableColumn(
        id: 'rPrice',
        label: 'R.PRICE',
        width: 90,
        isNumeric: true,
      ),
    ];
    final dtf = DateFormat('dd/MM/yy HH:mm');
    await TableExportService.exportAsExcel<TradeModel>(
      title: 'Trades',
      columns: columns,
      data: trades,
      cellValueExtractor: (t, col) {
        switch (col.id) {
          case 'userName':
            return t.userName;
          case 'pUser':
            return t.pUser;
          case 'exchange':
            return t.exchange;
          case 'symbol':
            return t.symbol;
          case 'orderDateTime':
            return dtf.format(t.orderDateTime);
          case 'buySell':
            return t.buySell;
          case 'qty':
            return t.qty.toStringAsFixed(2);
          case 'lot':
            return t.lot.toStringAsFixed(2);
          case 'orderType':
            return t.orderType;
          case 'pl':
            return t.pl.toStringAsFixed(2);
          case 'triggerPrice':
            return t.triggerPrice.toStringAsFixed(2);
          case 'brokerage':
            return t.brokerage.toStringAsFixed(2);
          case 'rPrice':
            return t.rPrice.toStringAsFixed(2);
          default:
            return '-';
        }
      },
    );
    return 'trades_${DateTime.now().millisecondsSinceEpoch}.xlsx';
  }

  List<TradeModel> _generateMockTrades() {
    final List<TradeModel> trades = [];
    final symbols = ['GOLD05DEC', 'SILVER05DEC', 'CRUDE05DEC'];
    final exchanges = ['MCX', 'NSE', 'CE/PE'];
    final users = ['PATIL', 'DEMO', 'DEMO4', 'DEMO12', 'DEMO49'];
    final pUsers = ['DEMO', 'DEMO49', 'DEMO12'];
    final buySellOptions = [
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
    for (int i = 0; i < 150; i++) {
      final isBuy = buySellOptions[i % buySellOptions.length].startsWith('BUY');
      trades.add(
        TradeModel(
          id: 'trade_$i',
          userName: users[i % users.length],
          pUser: pUsers[i % pUsers.length],
          exchange: exchanges[i % exchanges.length],
          symbol: symbols[i % symbols.length],
          orderDateTime: DateTime(2025, 11, 22, 3, 6, 34),
          buySell: buySellOptions[i % buySellOptions.length],
          qty: isBuy ? [100.0, 1000000.0, 100000.0][i % 3] : -500.0,
          lot: 1.0,
          orderType: 'Market',
          pl: 36200.0,
          triggerPrice: isBuy ? 124191.0 : -256.0,
          brokerage: 0.0,
          rPrice: 0.0,
          executionDateTime: DateTime(2025, 11, 22, 3, 6, 34),
          deviceId: 'E621E1F8-C36C-495A-93FC-0C247A3E6E5F',
          device: i % 2 == 0 ? 'IOS' : 'ANDROID',
          city: i % 2 == 0 ? 'Abu Dhabi' : 'Dubai',
          ipAddress: '192.0.2.1',
        ),
      );
    }
    return trades;
  }
}