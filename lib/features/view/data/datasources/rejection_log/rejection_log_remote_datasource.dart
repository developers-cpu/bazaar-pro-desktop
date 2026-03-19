import 'package:bazarpro/core/widget/table/table_export_service.dart';
import 'package:bazarpro/core/widget/table/view_data_table.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
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

class RejectionLogRemoteDataSourceImpl implements RejectionLogRemoteDataSource {
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
          matches =
              matches &&
              log.orderDateTime.isBefore(endDate.add(const Duration(days: 1)));
        }
        if (client != null && client.isNotEmpty) {
          matches = matches && log.userName == client;
        }
        if (exchange != null && exchange.isNotEmpty) {}
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
      return ['DEMO03'];
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
    const columns = [
      ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 150),
      ViewTableColumn(id: 'userName', label: 'U.NAME', width: 120),
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 120),
      ViewTableColumn(id: 'type', label: 'TYPE', width: 80),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 80, isNumeric: true),
      ViewTableColumn(id: 'price', label: 'PRICE', width: 90, isNumeric: true),
      ViewTableColumn(id: 'status', label: 'STATUS', width: 90),
      ViewTableColumn(id: 'comment', label: 'COMMENT', width: 200),
      ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 200),
      ViewTableColumn(id: 'device', label: 'DEVICE', width: 90),
      ViewTableColumn(id: 'city', label: 'CITY', width: 120),
      ViewTableColumn(
        id: 'ipAddress',
        label: 'IP',
        width: 120,
        isNumeric: true,
      ),
    ];
    final dtf = DateFormat('dd/MM/yy HH:mm');
    await TableExportService.exportAsPdf<RejectionLogModel>(
      title: 'Rejection Log',
      columns: columns,
      data: logs,
      cellValueExtractor: (l, col) {
        switch (col.id) {
          case 'orderDateTime':
            return dtf.format(l.orderDateTime);
          case 'userName':
            return l.userName;
          case 'exchange':
            return l.exchange;
          case 'symbol':
            return l.symbol;
          case 'type':
            return l.type;
          case 'qty':
            return l.qty.toStringAsFixed(2);
          case 'price':
            return l.price.toStringAsFixed(2);
          case 'status':
            return l.status;
          case 'comment':
            return l.comment;
          case 'deviceId':
            return l.deviceId;
          case 'device':
            return l.device;
          case 'city':
            return l.city;
          case 'ipAddress':
            return l.ipAddress;
          default:
            return '-';
        }
      },
    );
    return 'rejection_logs_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  @override
  Future<String> exportToExcel(List<RejectionLogModel> logs) async {
    const columns = [
      ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 150),
      ViewTableColumn(id: 'userName', label: 'U.NAME', width: 120),
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 120),
      ViewTableColumn(id: 'type', label: 'TYPE', width: 80),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 80, isNumeric: true),
      ViewTableColumn(id: 'price', label: 'PRICE', width: 90, isNumeric: true),
      ViewTableColumn(id: 'status', label: 'STATUS', width: 90),
      ViewTableColumn(id: 'comment', label: 'COMMENT', width: 200),
      ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 200),
      ViewTableColumn(id: 'device', label: 'DEVICE', width: 90),
      ViewTableColumn(id: 'city', label: 'CITY', width: 120),
      ViewTableColumn(
        id: 'ipAddress',
        label: 'IP',
        width: 120,
        isNumeric: true,
      ),
    ];
    final dtf = DateFormat('dd/MM/yy HH:mm');
    await TableExportService.exportAsExcel<RejectionLogModel>(
      title: 'Rejection Log',
      columns: columns,
      data: logs,
      cellValueExtractor: (l, col) {
        switch (col.id) {
          case 'orderDateTime':
            return dtf.format(l.orderDateTime);
          case 'userName':
            return l.userName;
          case 'exchange':
            return l.exchange;
          case 'symbol':
            return l.symbol;
          case 'type':
            return l.type;
          case 'qty':
            return l.qty.toStringAsFixed(2);
          case 'price':
            return l.price.toStringAsFixed(2);
          case 'status':
            return l.status;
          case 'comment':
            return l.comment;
          case 'deviceId':
            return l.deviceId;
          case 'device':
            return l.device;
          case 'city':
            return l.city;
          case 'ipAddress':
            return l.ipAddress;
          default:
            return '-';
        }
      },
    );
    return 'rejection_logs_${DateTime.now().millisecondsSinceEpoch}.xlsx';
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
      'SYMBOL BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
      'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    ];
    final baseDate = DateTime(2025, 4, 11, 1, 25, 35);
    final deviceId = 'E621E1F8-C36C-495A-93FC-0C247A3E6E5F';
    for (int i = 0; i < 50; i++) {
      logs.add(
        RejectionLogModel(
          id: 'rejection_log_$i',
          orderDateTime: baseDate,
          status: 'rejected',
          userName: users[i % users.length],
          symbol: symbols[i % symbols.length],
          exchange: 'MCX',
          type: types[i % types.length],
          qty: [
            95,
            178,
            50,
            1000000,
            125,
            30003,
            3000,
            2000,
            4000,
            10000,
            500,
            75,
            10000000,
            645,
            52,
          ][i % 15].toDouble(),
          price: [
            15000,
            5000,
            4598,
            6453,
            50000,
            30003,
            3000,
            2000,
            4000,
            10000,
            1025006,
            1025006,
            0,
            1025006,
            0,
          ][i % 15].toDouble(),
          comment: comments[i % comments.length],
          deviceId: deviceId,
          device: 'IOS',
          city: 'Abu Dabhi',
          ipAddress: '192.0.2.1',
          date: baseDate,
        ),
      );
    }
    return logs;
  }
}