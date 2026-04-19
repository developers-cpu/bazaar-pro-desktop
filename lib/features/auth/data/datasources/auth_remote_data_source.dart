import 'package:dio/dio.dart';

import '../../../../core/constants/auth_constants.dart';
import '../models/login_request_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginUserModel> login({
    required String username,
    required String password,
    int expiresInMins,
  });

  Future<LoginUserModel> refreshToken({required String refreshToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<LoginUserModel> login({
    required String username,
    required String password,
    int expiresInMins = 30,
  }) async {
    try {
      final request = LoginRequestModel(username: username, password: password);
      final response = await dio.post<Map<String, dynamic>>(
        AuthConstants.loginEndpoint,
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final payload = response.data;
      if (response.statusCode == 200 && payload != null) {
        final statusCode = payload['status_code'];
        if (statusCode != null && statusCode != 200) {
          throw Exception(_mapMessage(payload));
        }
        return LoginUserModel.fromLoginApi(payload);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Login failed',
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(_extractError(e.response!.data));
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Unexpected error: $e');
    }
  }

  String _mapMessage(Map<String, dynamic> payload) =>
      payload['message']?.toString() ?? 'Login failed';

  String _extractError(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['detail']?.toString() ??
          'Unknown error';
    }
    return data?.toString() ?? 'Unknown error';
  }

  @override
  Future<LoginUserModel> refreshToken({required String refreshToken}) async {
    final endpoint = AuthConstants.refreshTokenEndpoint;
    if (endpoint.isEmpty) {
      throw Exception('Refresh token is not configured');
    }
    try {
      final response = await dio.post<Map<String, dynamic>>(
        endpoint,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final payload = response.data;
      if (response.statusCode == 200 && payload != null) {
        return LoginUserModel.fromLoginApi(payload);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Token refresh failed',
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(_extractError(e.response!.data));
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
