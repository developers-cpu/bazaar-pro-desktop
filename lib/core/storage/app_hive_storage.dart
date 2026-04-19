import 'package:hive_flutter/hive_flutter.dart';

import '../constants/auth_constants.dart';

/// Central Hive access for the auth-session box ([AuthConstants.authHiveBoxName]).
/// Call [ensureAuthBoxOpen] once during startup (see [AppInitializer]); elsewhere
/// use [authBoxOrNull] / [authJwtOrNull] synchronously or [authBox] when async is ok.
class AppHiveStorage {
  AppHiveStorage._();

  /// Opens the auth box if needed. Safe to call multiple times.
  static Future<void> ensureAuthBoxOpen() async {
    if (!Hive.isBoxOpen(AuthConstants.authHiveBoxName)) {
      await Hive.openBox<dynamic>(AuthConstants.authHiveBoxName);
    }
  }

  /// The auth box when open; otherwise null (e.g. before bootstrap).
  static Box<dynamic>? get authBoxOrNull =>
      Hive.isBoxOpen(AuthConstants.authHiveBoxName)
          ? Hive.box<dynamic>(AuthConstants.authHiveBoxName)
          : null;

  /// JWT for API `Authorization`; null if box closed or token missing.
  static String? get authJwtOrNull {
    final value = authBoxOrNull?.get(AuthConstants.authHiveJwtKey);
    if (value is String && value.isNotEmpty) return value;
    return null;
  }

  /// Ensures the auth box exists and returns it (for repositories / writes).
  static Future<Box<dynamic>> authBox() async {
    await ensureAuthBoxOpen();
    return Hive.box<dynamic>(AuthConstants.authHiveBoxName);
  }

  /// Typed read when the box is already open (e.g. after startup).
  static T? get<T>(Object key) => authBoxOrNull?.get(key) as T?;

  /// Typed write; opens the auth box if needed.
  static Future<void> putValue(Object key, dynamic value) async {
    final box = await authBox();
    await box.put(key, value);
  }
}
