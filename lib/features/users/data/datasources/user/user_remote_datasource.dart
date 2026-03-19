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

      final statusStr = userStatus?.toLowerCase() ?? '';
      if (statusStr == 'inactive' || statusStr == 'in-active') {
        List<UserModel> inactiveUsers = _generateInactiveDummyUsers();
        if (userType != null && userType.isNotEmpty) {
          inactiveUsers = inactiveUsers
              .where((u) => u.type == userType)
              .toList();
        }
        return inactiveUsers;
      }

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
    final List<UserModel> users = [];

    UserModel create({
      required String id,
      required String userName,
      required String parentUser,
      required String type,
    }) {
      return UserModel(
        id: id,
        userName: userName,
        parentUser: parentUser,
        type: type,
        name: userName,
        plPercent: 40,
        brkPercent: 40,
        leverage: '1:1',
        credit: 100000,
        pl: 0,
        equity: 100000,
        totalMargin: 0,
        usedMargin: 0,
        freeMargin: 100000,
        createdDate: DateTime.now(),
        lastLoginDateTime: DateTime.now(),
        deviceType: 'Windows 11',
        ipAddress: '192.168.1.1',
        status: 'Active',
      );
    }

    users.add(
      create(id: '1', userName: 'RAJ03', parentUser: 'ADMIN', type: 'Master'),
    );

    final nestedMasters = [
      'ROCKYMASTER0925',
      'DEMO03',
      'DEMO89',
      'MARKOMASTER0925',
      'DEMOTRADERCLIENT298',
      'DEMO123',
    ];

    int idCounter = 2;
    for (String masterName in nestedMasters) {
      users.add(
        create(
          id: idCounter.toString(),
          userName: masterName,
          parentUser: 'RAJ03',
          type: 'Master',
        ),
      );
      idCounter++;

      for (int i = 1; i <= 2; i++) {
        users.add(
          create(
            id: idCounter.toString(),
            userName: '${masterName}_C$i',
            parentUser: masterName,
            type: 'Client',
          ),
        );
        idCounter++;
      }
    }

    return users;
  }

  List<UserModel> _generateInactiveDummyUsers() {
    final List<UserModel> users = [];
    final List<String> userNames = [
      'RAJ03',
      'MARKOMASTER0925',
      'ROCKYMASTER0925',
      'DEMOTRADERCLIENT298',
      'DEMO03',
      'DEMO123',
      'DEMO89',
    ];
    final List<String> types = ['Master', 'Client'];
    final List<String> names = ['RAJ', 'MARKO', 'ROCKY', 'DEMOTRADER', 'DEMO'];
    final List<String> parentUsers = ['DEMO', 'RAJ03'];

    for (int i = 0; i < 30; i++) {
      final plPercent = [0, 40, 100, 15, 60][i % 5].toDouble();
      final brkPercent = [40, 60, 100, 15][i % 4].toDouble();
      final type = types[i % 2];

      users.add(
        UserModel(
          id: 'inactive_$i',
          userName: userNames[i % userNames.length],
          parentUser: parentUsers[i % parentUsers.length],
          type: type,
          name: names[i % names.length],
          plPercent: plPercent,
          brkPercent: brkPercent,
          leverage: '1:1',
          credit: [
            0,
            5149,
            100000,
            2500000,
            1457987,
            45789,
            985647,
          ][i % 7].toDouble(),
          pl: [0, 1478, -4856, -25698, 41598][i % 5].toDouble(),
          equity: [
            0,
            1245668,
            47895,
            1568895,
            74596,
            10000059,
          ][i % 6].toDouble(),
          totalMargin: [
            4789,
            5000,
            1520000798,
            24568,
            12458,
            45789,
          ][i % 6].toDouble(),
          usedMargin: [0, -0.26, -0.43, -0.14][i % 4].toDouble(),
          freeMargin: [15698000, 50000, 25489, 124789, 62587][i % 5].toDouble(),
          createdDate: DateTime.now().subtract(Duration(days: i + 10)),
          lastLoginDateTime: DateTime.now().subtract(Duration(days: i + 5)),
          deviceType: ['Windows 11', 'Android', 'iOS', 'Mac mini'][i % 4],
          ipAddress: ['192.168.1.1', '2.52.154.153', '49.36.125.45'][i % 3],
          status: 'In-Active',
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