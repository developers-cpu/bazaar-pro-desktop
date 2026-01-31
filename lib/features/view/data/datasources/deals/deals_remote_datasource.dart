import 'package:dio/dio.dart';
import '../../models/deals/deals_model.dart';

abstract class DealsRemoteDataSource {
  Future<List<DealModel>> getDeals();
  Future<List<DealModel>> getDealsWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
    String? orderType,
    String? status,
  });
  Future<List<String>> getClients();
  Future<List<String>> getExchanges();
  Future<List<String>> getSymbols();
  Future<List<String>> getOrderTypes();
  Future<List<String>> getStatuses();
  Future<String> exportToPdf(List<DealModel> deals);
  Future<String> exportToExcel(List<DealModel> deals);
}

class DealsRemoteDataSourceImpl implements DealsRemoteDataSource {
  final Dio dio;

  DealsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DealModel>> getDeals() async {
    try {

      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockDeals();
    } catch (e) {
      throw Exception('Failed to fetch deals: $e');
    }
  }

  @override
  Future<List<DealModel>> getDealsWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
    String? orderType,
    String? status,
  }) async {
    try {

      await Future.delayed(const Duration(milliseconds: 300));

      final allDeals = await getDeals();

      return allDeals.where((deal) {
        bool matches = true;

        if (startDate != null) {
          matches = matches && deal.orderDateTime.isAfter(startDate);
        }
        if (endDate != null) {
          matches = matches && deal.orderDateTime.isBefore(endDate.add(const Duration(days: 1)));
        }
        if (client != null && client.isNotEmpty) {
          matches = matches && deal.userName == client;
        }
        if (exchange != null && exchange.isNotEmpty && exchange != 'All') {
          matches = matches && deal.exchange == exchange;
        }
        if (symbol != null && symbol.isNotEmpty) {
          matches = matches && deal.symbol == symbol;
        }
        if (orderType != null && orderType.isNotEmpty && orderType != 'All') {
          matches = matches && deal.buySell.toLowerCase().startsWith(orderType.toLowerCase());
        }
        if (status != null && status.isNotEmpty && status != 'All') {
          matches = matches && deal.status == status;
        }

        return matches;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch filtered deals: $e');
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
      return ['NSE', 'MCX', 'CE/PE', 'OTHERS', 'COMEX', 'CRYPTO', 'GIFT', 'FOREX'];
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
        'MCX SILVER Dec 05',
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
  Future<List<String>> getStatuses() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['All', 'Market', 'Intraday', 'Settled', 'Pending to Success', 'Super Admin'];
    } catch (e) {
      throw Exception('Failed to fetch statuses: $e');
    }
  }

  @override
  Future<String> exportToPdf(List<DealModel> deals) async {
    try {

      await Future.delayed(const Duration(seconds: 1));
      return 'deals_export_${DateTime.now().millisecondsSinceEpoch}.pdf';
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  @override
  Future<String> exportToExcel(List<DealModel> deals) async {
    try {

      await Future.delayed(const Duration(seconds: 1));
      return 'deals_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    } catch (e) {
      throw Exception('Failed to export Excel: $e');
    }
  }

  List<DealModel> _generateMockDeals() {
    final List<DealModel> deals = [];
    final symbols = ['GOLD05DEC', 'SILVER05DEC', 'CRUDE05DEC', 'MCX SILVER Dec 05'];
    final exchanges = ['MCX', 'NSE', 'CE/PE'];
    final users = ['PATIL', 'DEMO', 'DEMO4', 'DEMO12', 'DEMO49'];
    final pUsers = ['DEMO', 'DEMO49', 'DEMO12'];
    final statuses = ['Market', 'Intraday', 'Settled', 'Pending to Success', 'Super Admin'];
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
      'BUY Limit',
      'SELL',
    ];

    for (int i = 0; i < 150; i++) {
      final isBuy = buySellOptions[i % buySellOptions.length].startsWith('BUY');
      final orderDate = DateTime(2025, 11, 22, 3, 6, 34);
      final executionDate = DateTime(2025, 11, 22, 3, 6, 34);

      final duration = DateTime.now().difference(orderDate);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final orderDuration = '$hours hours $minutes minutes';

      deals.add(DealModel(
        id: 'deal_$i',
        userName: users[i % users.length],
        pUser: pUsers[i % pUsers.length],
        exchange: exchanges[i % exchanges.length],
        symbol: symbols[i % symbols.length],
        orderDateTime: orderDate,
        buySell: buySellOptions[i % buySellOptions.length],
        qty: isBuy ? [100.0, 1000000.0, 100000.0, 5000.0][i % 4] : -500.0,
        lot: 1.0,
        orderType: i % 3 == 0 ? 'Buy Limit' : 'Market',
        pl: i % 5 == 0 ? -256.0 : [36200.0, 1000000.0, -1000000.0][i % 3],
        triggerPrice: isBuy ? [124191.0, 1000000.0][i % 2] : -256.0,
        brokerage: 0.0,
        rPrice: 0.0,
        executionDateTime: executionDate,
        deviceId: 'E621E1F8-C36C-495A-93FC-0C247A3E6E5F',
        ipAddress: '192.0.2.1',
        orderDuration: i % 2 == 0 ? orderDuration : '3 hours 20 min',
        status: statuses[i % statuses.length],
      ));
    }

    return deals;
  }
}