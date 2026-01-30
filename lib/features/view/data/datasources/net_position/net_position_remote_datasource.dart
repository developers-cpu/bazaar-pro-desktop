import 'package:dio/dio.dart';
import '../../models/net_postion/net_position_model.dart';


abstract class NetPositionRemoteDataSource {
  Future<List<NetPositionModel>> getNetPositions();
  Future<List<NetPositionModel>> getNetPositionsWithFilters({
    String? userType,
    String? client,
    String? exchange,
    String? symbol,
  });
  Future<List<String>> getClients();
  Future<List<String>> getExchanges();
  Future<List<String>> getSymbols();
  Future<List<String>> getUserTypes();
  Future<String> exportToPdf(List<NetPositionModel> positions);
  Future<String> exportToExcel(List<NetPositionModel> positions);
  Future<List<NetPositionModel>> getPositionDetails({
    required String symbol,
    required String userName,
  });
}


class NetPositionRemoteDataSourceImpl implements NetPositionRemoteDataSource {
  final Dio dio;

  NetPositionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NetPositionModel>> getNetPositions() async {
    try {
      
      
      

      
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockNetPositions();
    } catch (e) {
      throw Exception('Failed to fetch net positions: $e');
    }
  }

  @override
  Future<List<NetPositionModel>> getNetPositionsWithFilters({
    String? userType,
    String? client,
    String? exchange,
    String? symbol,
  }) async {
    try {
      
      await Future.delayed(const Duration(milliseconds: 300));

      final allPositions = await getNetPositions();

      return allPositions.where((position) {
        bool matches = true;

        if (client != null && client.isNotEmpty) {
          matches = matches && position.userName == client;
        }
        if (exchange != null && exchange.isNotEmpty && exchange != 'All') {
          matches = matches && position.exchange == exchange;
        }
        if (symbol != null && symbol.isNotEmpty) {
          matches = matches && position.symbol.contains(symbol);
        }

        return matches;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch filtered net positions: $e');
    }
  }

  @override
  Future<List<String>> getClients() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['DEMO11', 'DEMO012', 'DEMO02', 'PATIL', 'DEMO4', 'DEMO12', 'DEMO49'];
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
  Future<List<String>> getUserTypes() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['All', 'Master', 'Client'];
    } catch (e) {
      throw Exception('Failed to fetch user types: $e');
    }
  }

  @override
  Future<String> exportToPdf(List<NetPositionModel> positions) async {
    try {
      
      await Future.delayed(const Duration(seconds: 1));
      return 'net_positions_export_${DateTime.now().millisecondsSinceEpoch}.pdf';
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  @override
  Future<String> exportToExcel(List<NetPositionModel> positions) async {
    try {
      
      await Future.delayed(const Duration(seconds: 1));
      return 'net_positions_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    } catch (e) {
      throw Exception('Failed to export Excel: $e');
    }
  }

  @override
  Future<List<NetPositionModel>> getPositionDetails({
    required String symbol,
    required String userName,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      
      final allPositions = await getNetPositions();
      return allPositions
          .where((position) =>
      position.symbol == symbol && position.userName.contains(userName))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch position details: $e');
    }
  }

  
  List<NetPositionModel> _generateMockNetPositions() {
    final List<NetPositionModel> positions = [];
    final symbols = ['GOLD05DEC', 'SILVER05DEC', 'CRUDE05DEC', 'MCX SILVER Dec 05'];
    final exchanges = ['MCX', 'NSE', 'CE/PE'];
    final users = ['DEMO11', 'DEMO012', 'DEMO02', 'PATIL'];
    final pUsers = ['DEMO', 'DEMO49', 'DEMO12'];

    for (int i = 0; i < 50; i++) {
      final buyQty = [10000.0, 0.0, 1.0][i % 3];
      final sellQty = buyQty == 0.0 ? 1.0 : 0.0;
      final netQty = buyQty - sellQty;
      final netAvgPrice = [90792.00, 130319.73, 36200.00, 9000.00][i % 4];
      final cmp = [124536.00, 124191.00][i % 2];
      final m2mAmount = cmp;

      positions.add(NetPositionModel(
        id: 'position_$i',
        userName: users[i % users.length],
        pUser: pUsers[i % pUsers.length],
        exchange: exchanges[i % exchanges.length],
        symbol: symbols[i % symbols.length],
        buyQty: buyQty,
        sellQty: sellQty,
        netQty: netQty,
        netAvgPrice: netAvgPrice,
        cmp: cmp,
        m2mAmount: m2mAmount,
        ourPercentage: 0.00,
        userCount: [1, 2][i % 2],
        days: [1, 2][i % 2],
        lastUpdated: DateTime.now().subtract(Duration(hours: i)),
        status: 'Active',
      ));
    }

    return positions;
  }
}