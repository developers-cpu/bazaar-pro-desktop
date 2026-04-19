import 'dart:convert';

import '../../../../core/constants/auth_constants.dart';
import '../../../../core/storage/app_hive_storage.dart';
import '../models/user_model.dart';

/// Credentials + role persisted for session restore and login field prefilling.
class SavedAuthCredentials {
  const SavedAuthCredentials({
    this.username,
    this.password,
    this.role,
  });

  final String? username;
  final String? password;
  final String? role;
}

abstract class AuthLocalDataSource {
  /// Persists session tokens, full user payload (includes [LoginUserModel.role]),
  /// and optionally the plaintext username/password used for login.
  Future<void> saveSession(
    LoginUserModel user, {
    String? loginUsername,
    String? loginPassword,
  });

  Future<LoginUserModel?> loadSession();

  /// Values written by [saveSession] for form prefilling (e.g. after logout).
  Future<SavedAuthCredentials?> loadSavedCredentials();

  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl();

  @override
  Future<void> saveSession(
    LoginUserModel user, {
    String? loginUsername,
    String? loginPassword,
  }) async {
    final box = await AppHiveStorage.authBox();
    await box.put(
      AuthConstants.authHiveUserKey,
      jsonEncode(user.toPersistedJson()),
    );
    await box.put(AuthConstants.authHiveJwtKey, user.accessToken);
    await box.put(AuthConstants.authHiveApiTokenKey, user.refreshToken);
    await box.put(AuthConstants.authHiveRoleKey, user.role);
    if (loginUsername != null) {
      await box.put(AuthConstants.authHiveSavedUsernameKey, loginUsername);
    }
    if (loginPassword != null) {
      await box.put(AuthConstants.authHiveSavedPasswordKey, loginPassword);
    }
  }

  @override
  Future<LoginUserModel?> loadSession() async {
    final box = await AppHiveStorage.authBox();
    final raw = box.get(AuthConstants.authHiveUserKey);
    if (raw is! String || raw.isEmpty) return null;
    final roleFromKey = box.get(AuthConstants.authHiveRoleKey) as String?;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return LoginUserModel.fromPersistedJson(map, roleFallback: roleFromKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SavedAuthCredentials?> loadSavedCredentials() async {
    final box = await AppHiveStorage.authBox();
    final username = box.get(AuthConstants.authHiveSavedUsernameKey) as String?;
    final password = box.get(AuthConstants.authHiveSavedPasswordKey) as String?;
    final role = box.get(AuthConstants.authHiveRoleKey) as String?;
    if ((username == null || username.isEmpty) &&
        (password == null || password.isEmpty) &&
        (role == null || role.isEmpty)) {
      return null;
    }
    return SavedAuthCredentials(
      username: username,
      password: password,
      role: role,
    );
  }

  @override
  Future<void> clearSession() async {
    final box = await AppHiveStorage.authBox();
    await box.clear();
  }
}
