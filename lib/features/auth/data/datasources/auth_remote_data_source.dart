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
      final request = LoginRequestModel(
        username: username,
        password: password,
        expiresInMins: expiresInMins,
      );
      final response = await dio.post(
        AuthConstants.loginEndpoint,
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        return LoginUserModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Login failed',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Login failed: ${e.response?.data['message'] ?? 'Unknown error'}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  @override
  Future<LoginUserModel> refreshToken({required String refreshToken}) async {
    try {
      final response = await dio.post(
        AuthConstants.refreshTokenEndpoint,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        return LoginUserModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Token refresh failed',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Token refresh failed: ${e.response?.data['message'] ?? 'Unknown error'}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
