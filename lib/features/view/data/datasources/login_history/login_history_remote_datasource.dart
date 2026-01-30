import 'package:dio/dio.dart';
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
      return ['Client 1', 'Client 2', 'Client 3', 'Client 4', 'Client 5'];
    } catch (e) {
      throw Exception('Failed to fetch clients: $e');
    }
  }

  @override
  Future<String> exportToPdf(List<LoginHistoryModel> history) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'login_history_${DateTime.now().millisecondsSinceEpoch}.pdf';
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  @override
  Future<String> exportToExcel(List<LoginHistoryModel> history) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'login_history_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    } catch (e) {
      throw Exception('Failed to export Excel: $e');
    }
  }

  
  List<LoginHistoryModel> _generateMockLoginHistory(String client) {
    final List<LoginHistoryModel> history = [];
    final userTypes = ['MASTER', 'CLIENT'];

    final dates = [
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
      final dateIndex = i % dates.length;

      history.add(LoginHistoryModel(
        id: 'login_$i',
        index: i + 1,
        loginTime: dates[dateIndex],
        userName: 'DEMO',
        userType: userTypes[i % userTypes.length],
        ipAddress: '103.60.95.6',
        deviceId: '042590A-6578-4D7C-82E0-D10CF23',
      ));
    }

    return history;
  }
}