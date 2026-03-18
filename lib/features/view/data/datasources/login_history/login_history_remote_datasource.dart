import 'package:bazarpro/core/widget/table/table_export_service.dart';
import 'package:bazarpro/core/widget/table/view_data_table.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../models/login_history/login_history_model.dart';

abstract class LoginHistoryRemoteDataSource {
  Future<List<LoginHistoryModel>> getLoginHistory(String client);
  Future<List<String>> getClients();
  Future<String> exportToPdf(List<LoginHistoryModel> history);
  Future<String> exportToExcel(List<LoginHistoryModel> history);
}

class LoginHistoryRemoteDataSourceImpl implements LoginHistoryRemoteDataSource {
  final Dio dio;
  LoginHistoryRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<LoginHistoryModel>> getLoginHistory(String client) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockLoginHistory(client);
    } catch (e) {
      throw Exception('Failed to fetch login history: $e');
    }
  }

  @override
  Future<List<String>> getClients() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['User 1', 'User 2', 'User 3', 'User 4', 'User 5'];
    } catch (e) {
      throw Exception('Failed to fetch clients: $e');
    }
  }

  @override
  Future<String> exportToPdf(List<LoginHistoryModel> history) async {
    const columns = [
      ViewTableColumn(id: 'index', label: '#', width: 50, isNumeric: true),
      ViewTableColumn(id: 'userName', label: 'U.NAME', width: 120),
      ViewTableColumn(id: 'userType', label: 'TYPE', width: 90),
      ViewTableColumn(id: 'loginTime', label: 'LOGIN TIME', width: 150),
      ViewTableColumn(id: 'logoutTime', label: 'LOGOUT TIME', width: 150),
      ViewTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 130),
      ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 200),
      ViewTableColumn(id: 'device', label: 'DEVICE', width: 90),
      ViewTableColumn(id: 'city', label: 'CITY', width: 120),
    ];
    final dtf = DateFormat('dd/MM/yy HH:mm');
    await TableExportService.exportAsPdf<LoginHistoryModel>(
      title: 'Login History',
      columns: columns,
      data: history,
      cellValueExtractor: (h, col) {
        switch (col.id) {
          case 'index':
            return h.index.toString();
          case 'userName':
            return h.userName;
          case 'userType':
            return h.userType;
          case 'loginTime':
            return dtf.format(h.loginTime);
          case 'logoutTime':
            return dtf.format(h.logoutTime);
          case 'ipAddress':
            return h.ipAddress;
          case 'deviceId':
            return h.deviceId;
          case 'device':
            return h.device;
          case 'city':
            return h.city;
          default:
            return '-';
        }
      },
    );
    return 'login_history_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  @override
  Future<String> exportToExcel(List<LoginHistoryModel> history) async {
    const columns = [
      ViewTableColumn(id: 'index', label: '#', width: 50, isNumeric: true),
      ViewTableColumn(id: 'userName', label: 'U.NAME', width: 120),
      ViewTableColumn(id: 'userType', label: 'TYPE', width: 90),
      ViewTableColumn(id: 'loginTime', label: 'LOGIN TIME', width: 150),
      ViewTableColumn(id: 'logoutTime', label: 'LOGOUT TIME', width: 150),
      ViewTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 130),
      ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 200),
      ViewTableColumn(id: 'device', label: 'DEVICE', width: 90),
      ViewTableColumn(id: 'city', label: 'CITY', width: 120),
    ];
    final dtf = DateFormat('dd/MM/yy HH:mm');
    await TableExportService.exportAsExcel<LoginHistoryModel>(
      title: 'Login History',
      columns: columns,
      data: history,
      cellValueExtractor: (h, col) {
        switch (col.id) {
          case 'index':
            return h.index.toString();
          case 'userName':
            return h.userName;
          case 'userType':
            return h.userType;
          case 'loginTime':
            return dtf.format(h.loginTime);
          case 'logoutTime':
            return dtf.format(h.logoutTime);
          case 'ipAddress':
            return h.ipAddress;
          case 'deviceId':
            return h.deviceId;
          case 'device':
            return h.device;
          case 'city':
            return h.city;
          default:
            return '-';
        }
      },
    );
    return 'login_history_${DateTime.now().millisecondsSinceEpoch}.xlsx';
  }

  List<LoginHistoryModel> _generateMockLoginHistory(String client) {
    final List<LoginHistoryModel> history = [];
    final userTypes = ['MASTER', 'CLIENT'];
    final devices = ['IOS', 'ANDROID', 'WEB'];
    final loginDates = [
      DateTime(2025, 11, 14, 16, 32, 16),
      DateTime(2025, 11, 14, 10, 16, 13),
      DateTime(2025, 11, 13, 16, 40, 23),
      DateTime(2025, 11, 6, 16, 19, 43),
      DateTime(2025, 11, 1, 15, 46, 29),
      DateTime(2025, 10, 30, 21, 5, 3),
      DateTime(2025, 10, 28, 13, 19, 59),
      DateTime(2025, 10, 28, 13, 19, 53),
      DateTime(2025, 10, 28, 22, 29, 41),
      DateTime(2025, 10, 28, 21, 51, 6),
    ];
    final logoutDates = [
      DateTime(2025, 11, 14, 16, 32, 16),
      DateTime(2025, 11, 14, 10, 16, 13),
      DateTime(2025, 11, 13, 16, 40, 23),
      DateTime(2025, 11, 6, 16, 19, 43),
      DateTime(2025, 11, 1, 15, 46, 29),
      DateTime(2025, 10, 30, 21, 5, 3),
      DateTime(2025, 10, 28, 13, 19, 59),
      DateTime(2025, 10, 28, 13, 19, 53),
      DateTime(2025, 10, 28, 22, 29, 41),
      DateTime(2025, 10, 28, 21, 51, 6),
    ];
    for (int i = 0; i < 50; i++) {
      final dateIndex = i % loginDates.length;
      history.add(
        LoginHistoryModel(
          id: 'login_$i',
          index: i + 1,
          loginTime: loginDates[dateIndex],
          logoutTime: logoutDates[dateIndex],
          userName: 'DEMO',
          userType: userTypes[i % userTypes.length],
          ipAddress: '103.60.95.6',
          deviceId: '042590A-6578-4D7C-82E0-D10CF23',
          device: devices[i % devices.length],
          city: 'Abu dabhi',
        ),
      );
    }
    return history;
  }
}
