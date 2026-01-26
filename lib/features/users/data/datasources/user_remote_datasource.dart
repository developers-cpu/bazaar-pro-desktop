import 'package:dio/dio.dart';
import '../models/user_model.dart';

/// Abstract class for User Remote Data Source
abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<List<UserModel>> getUsersWithFilters({
    String? userType,
    String? userStatus,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      // TODO: Replace with actual API endpoint
      // final response = await dio.get('/api/users');
      // return (response.data as List)
      //     .map((json) => UserModel.fromJson(json))
      //     .toList();

      // For now, return dummy data
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateDummyUsers();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsersWithFilters({
    String? userType,
    String? userStatus,
  }) async {
    try {
      // TODO: Replace with actual API endpoint with query params
      // final response = await dio.get('/api/users', queryParameters: {
      //   if (userType != null) 'user_type': userType,
      //   if (userStatus != null) 'status': userStatus,
      // });

      await Future.delayed(const Duration(milliseconds: 300));
      final allUsers = _generateDummyUsers();

      return allUsers.where((user) {
        if (userType != null && userType.isNotEmpty && user.type != userType) {
          return false;
        }
        if (userStatus != null && userStatus.isNotEmpty) {
          final isActive = userStatus.toLowerCase() == 'active';
          if (user.isActive != isActive) {
            return false;
          }
        }
        return true;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch filtered users: $e');
    }
  }

  List<UserModel> _generateDummyUsers() {
    final List<String> userNames = [
      'RAJ03',
      'MARKOMASTER0925',
      'ROCKYMASTER0925',
      'DEMOTRADERCLIENT298',
      'DEMO03',
      'DEMO123',
      'DEMO89',
    ];
    final List<String> parentUsers = ['DEMO', 'RAJ03'];
    final List<String> types = ['Master', 'Client'];
    final List<String> names = ['RAJ', 'MARKO', 'ROCKY', 'DEMOTRADER', 'DEMO'];
    final List<String> leverages = ['1:1'];
    final List<String> deviceTypes = [
      'Windows 11 Home Single Language',
      'Windows 11Pro',
      'Windows 11 Home',
      'Windows 10',
      'Mac mini',
      'Android',
      'ios',
    ];
    final List<String> ipAddresses = [
      '2.52.154.153.98',
      '49.36.125.45',
      '0.00.000.00.000',
    ];

    final List<UserModel> users = [];

    for (int i = 0; i < 50; i++) {
      final plPercent = [0, 40, 100, 15, 60][i % 5].toDouble();
      final brkPercent = [40, 60, 100, 15][i % 4].toDouble();
      final type = types[i % types.length];
      final status = i % 5 == 0 ? 'In-Active' : 'Active';

      users.add(
        UserModel(
          id: 'user_$i',
          userName: userNames[i % userNames.length],
          parentUser: parentUsers[i % parentUsers.length],
          type: type,
          name: names[i % names.length],
          plPercent: plPercent,
          brkPercent: brkPercent,
          leverage: leverages[0],
          credit: [
            0,
            5149,
            100000,
            2500000,
            1457987,
            45789,
            985647,
            1254689,
            24569,
            147997,
            50000,
            24789,
            10578,
            45789,
          ][i % 14].toDouble(),
          pl: [0, 1478, -4856, -25698, 41598][i % 5].toDouble(),
          equity: [
            0,
            1245668,
            47895,
            1568895,
            74596,
            10000059,
            2547895,
            45995,
            25478,
            41598,
            784595,
            2458969,
          ][i % 12].toDouble(),
          totalMargin: [
            4789,
            5000,
            1520000798,
            24568,
            12458,
            45789,
            12478,
            54289,
            350478,
            42698,
            154798,
            1257895,
            89245,
          ][i % 13].toDouble(),
          usedMargin: [0, -0.26, -0.43, -0.14][i % 4].toDouble(),
          freeMargin: [
            15698000,
            50000,
            25489,
            124789,
            62587,
            174595,
            2500789,
            10000000,
            75125,
          ][i % 9].toDouble(),
          createdDate: DateTime(2025, 11, 25, 1, 33, 04),
          lastLoginDateTime: DateTime(2025, 11, 25, 1, 33, 04),
          deviceType: deviceTypes[i % deviceTypes.length],
          ipAddress: ipAddresses[i % ipAddresses.length],
          status: status,
        ),
      );
    }

    return users;
  }
}
