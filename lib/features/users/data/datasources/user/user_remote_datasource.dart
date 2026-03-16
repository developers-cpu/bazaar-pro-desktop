import 'package:bazarpro/features/users/data/models/user/user_model.dart';
import 'package:dio/dio.dart';
abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<List<UserModel>> getUsersWithFilters({
    String? userType,
    String? userStatus,
  });
  Future<List<String>> getExchanges();
  Future<List<String>> getSymbols(String? exchange);
  Future<List<UserModel>> getNestedUsers(String parentUserId);
}
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;
  UserRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<UserModel>> getUsers() async {
    try {
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
            135,
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
  @override
  Future<List<String>> getExchanges() async {
    await Future.delayed(const Duration(milliseconds: 300));
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
  }
  @override
  Future<List<String>> getSymbols(String? exchange) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (exchange == 'NSE') {
      return ['NIFTY Oct 28', 'BANKNIFTY Oct 28', 'RELIANCE', 'TATASTEEL'];
    } else if (exchange == 'MCX') {
      return ['GOLD05DEC', 'SILVER05DEC', 'CRUDEOIL', 'NATURAL'];
    }
    return [
      'NIFTY Oct 28',
      'BANKNIFTY Oct 28',
      'GOLD05DEC',
      'SILVER05DEC',
      'RELIANCE',
      'TATASTEEL',
    ];
  }
  @override
  Future<List<UserModel>> getNestedUsers(String parentUserId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      UserModel(
        id: '1',
        userName: 'RAJ03',
        name: 'RAJ',
        type: 'Master',
        parentUser: parentUserId,
        credit: 0,
        plPercent: 40,
        brkPercent: 40,
        leverage: '100',
        status: 'Active',
        totalMargin: 0,
        usedMargin: 0,
        freeMargin: 0,
        pl: 0,
        equity: 40,
        createdDate: DateTime.now(),
        lastLoginDateTime: DateTime.now(),
        deviceType: 'Android',
        ipAddress: '192.168.1.1',
      ),
      UserModel(
        id: '2',
        userName: 'CLIENT01',
        name: 'Client One',
        type: 'Client',
        parentUser: parentUserId,
        credit: 100000,
        plPercent: 100,
        brkPercent: 60,
        leverage: '100',
        status: 'Active',
        totalMargin: 0,
        usedMargin: 0,
        freeMargin: 0,
        pl: 0,
        equity: 100,
        createdDate: DateTime.now(),
        lastLoginDateTime: DateTime.now(),
        deviceType: 'Android',
        ipAddress: '192.168.1.2',
      ),
      UserModel(
        id: '3',
        userName: 'CLIENT02',
        name: 'Client Two',
        type: 'Client',
        parentUser: parentUserId,
        credit: 50000,
        plPercent: 80,
        brkPercent: 50,
        leverage: '50',
        status: 'Active',
        totalMargin: 25000,
        usedMargin: 5000,
        freeMargin: 20000,
        pl: 1500,
        equity: 51500,
        createdDate: DateTime.now(),
        lastLoginDateTime: DateTime.now(),
        deviceType: 'iOS',
        ipAddress: '192.168.1.3',
      ),
    ];
  }
}
