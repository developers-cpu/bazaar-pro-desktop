import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/auth_constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession(LoginUserModel user);

  Future<LoginUserModel?> loadSession();

  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl();

  Future<Box<dynamic>> _box() async {
    if (Hive.isBoxOpen(AuthConstants.authHiveBoxName)) {
      return Hive.box<dynamic>(AuthConstants.authHiveBoxName);
    }
    return Hive.openBox<dynamic>(AuthConstants.authHiveBoxName);
  }

  @override
  Future<void> saveSession(LoginUserModel user) async {
    final box = await _box();
    await box.put(
      AuthConstants.authHiveUserKey,
      jsonEncode(user.toPersistedJson()),
    );
    await box.put(AuthConstants.authHiveJwtKey, user.accessToken);
    await box.put(AuthConstants.authHiveApiTokenKey, user.refreshToken);
  }

  @override
  Future<LoginUserModel?> loadSession() async {
    final box = await _box();
    final raw = box.get(AuthConstants.authHiveUserKey);
    if (raw is! String || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return LoginUserModel.fromPersistedJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    final box = await _box();
    await box.clear();
  }
}
