import 'package:dio/dio.dart';

import '../constants/auth_constants.dart';
import '../storage/app_hive_storage.dart';

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
          if (!path.contains('/auth/login')) {
            final jwt = AppHiveStorage.authJwtOrNull;
            if (jwt != null) {
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
