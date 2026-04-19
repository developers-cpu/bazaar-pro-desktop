import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/auth_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  factory ApiClient() => _instance;
  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: AuthConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final path = options.uri.path;
          if (!path.contains('/auth/login') &&
              Hive.isBoxOpen(AuthConstants.authHiveBoxName)) {
            final jwt = Hive.box<dynamic>(AuthConstants.authHiveBoxName).get(
                  AuthConstants.authHiveJwtKey,
                )
                as String?;
            if (jwt != null && jwt.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $jwt';
            }
          }
          return handler.next(options);
        },
      ),
    );
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }
  Dio get client => dio;
}
