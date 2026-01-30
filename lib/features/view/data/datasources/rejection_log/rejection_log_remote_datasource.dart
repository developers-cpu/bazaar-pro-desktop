import 'package:dio/dio.dart';
import '../../models/rejection_log/rejection_log_model.dart';


abstract class RejectionLogRemoteDataSource {
  Future<List<RejectionLogModel>> getRejectionLogs();

  Future<List<RejectionLogModel>> getRejectionLogsWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
  });

  Future<List<String>> getClients();
  Future<List<String>> getExchanges();
  Future<List<String>> getSymbols();

  Future<String> exportToPdf(List<RejectionLogModel> logs);
  Future<String> exportToExcel(List<RejectionLogModel> logs);
}


class RejectionLogRemoteDataSourceImpl
    implements RejectionLogRemoteDataSource {
  final Dio dio;

  RejectionLogRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RejectionLogModel>> getRejectionLogs() async {
    try {
      
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockRejectionLogs();
    } catch (e) {
      throw Exception('Failed to fetch rejection logs: $e');
    }
  }

  @override
  Future<List<RejectionLogModel>> getRejectionLogsWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final allLogs = await getRejectionLogs();

      return allLogs.where((log) {
        bool matches = true;

        if (startDate != null) {
          matches = matches && log.orderDateTime.isAfter(startDate);
        }
        if (endDate != null) {
          matches = matches &&
              log.orderDateTime
                  .isBefore(endDate.add(const Duration(days: 1)));
        }
        if (client != null && client.isNotEmpty) {
          matches = matches && log.userName == client;
        }
        if (exchange != null && exchange.isNotEmpty) {
          
          
        }
        if (symbol != null && symbol.isNotEmpty) {
          matches = matches && log.symbol == symbol;
        }

        return matches;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch filtered rejection logs: $e');
    }
  }

  @override
  Future<List<String>> getClients() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['Client 1', 'Client 2', 'Client 3'];
    } catch (e) {
      throw Exception('Failed to fetch clients: $e');
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
      return [
        'NIFTY25N042555OCE',
        'GOLD',
        'GOLD05DEC',
        'SILVER',
        'CRUDEOIL20OCT',
        'SILVER05DEC',
      ];
    } catch (e) {
      throw Exception('Failed to fetch symbols: $e');
    }
  }

  @override
  Future<String> exportToPdf(List<RejectionLogModel> logs) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'rejection_logs_${DateTime.now().millisecondsSinceEpoch}.pdf';
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  @override
  Future<String> exportToExcel(List<RejectionLogModel> logs) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'rejection_logs_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    } catch (e) {
      throw Exception('Failed to export Excel: $e');
    }
  }

  
  List<RejectionLogModel> _generateMockRejectionLogs() {
    final List<RejectionLogModel> logs = [];
    final symbols = [
      'NIFTY25N042555OCE',
      'GOLD',
      'GOLD05DEC',
      'SILVER',
      'CRUDEOIL20OCT',
      'SILVER05DEC',
    ];
    final users = ['DEMO03'];
    final types = ['BUY', 'SELL'];
    final comments = [
      'SYMBOL BLOCKED IF YOU HAVE POSITION ',
      'SCRIPT BLOCKED IF YOU HAVE POSITION ',
    ];

    final baseDate = DateTime(2025, 4, 11, 1, 25, 35);

    for (int i = 0; i < 50; i++) {
      logs.add(RejectionLogModel(
        id: 'rejection_log_$i',
        orderDateTime: baseDate,
        userName: users[i % users.length],
        symbol: symbols[i % symbols.length],
        type: types[i % types.length],
        qty: [95, 178, 50, 1000000, 125, 30003, 3000, 2000, 4000, 10000, 500,
          75, 10000000, 645, 52][i % 15]
            .toDouble(),
        price: [15000, 5000, 4598, 6453, 50000, 30003, 3000, 2000, 4000, 10000,
          1025006, 1025006, 0, 1025006, 0][i % 15]
            .toDouble(),
        comment: comments[i % comments.length],
        date: baseDate,
      ));
    }

    return logs;
  }
}