import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Contract untuk auth remote data source.
abstract class AuthRemoteDataSource {
  /// Login dan mengembalikan [AuthResult] berisi user + tokens.
  Future<AuthResult> login({
    required String phoneNumber,
    required String password,
  });

  /// Register customer baru dan mengembalikan [AuthResult].
  Future<AuthResult> register({
    required String name,
    required String phoneNumber,
    required String password,
  });

  Future<UserModel> getCurrentUser();

  Future<void> updateFcmToken(String token);
}

/// Data class untuk menampung hasil login/register dari API.
///
/// API response bentuknya:
/// ```json
/// {
///   "success": true,
///   "data": {
///     "accessToken": "...",
///     "refreshToken": "...",
///     "user": { ... }
///   }
/// }
/// ```
class AuthResult {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  const AuthResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
}

/// Implementasi AuthRemoteDataSource menggunakan Dio.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  const AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResult> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'nomor_telepon': phoneNumber, 'password': password},
      );

      final responseData = response.data['data'] as Map<String, dynamic>;

      return AuthResult(
        user: UserModel.fromJson(responseData['user'] as Map<String, dynamic>),
        accessToken: responseData['accessToken'] as String,
        refreshToken: responseData['refreshToken'] as String,
      );
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            e.message ??
            'Login gagal',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {
          'nama': name,
          'nomor_telepon': phoneNumber,
          'password': password,
        },
      );

      final responseData = response.data['data'] as Map<String, dynamic>;

      // Jika register langsung return token + user (seperti login)
      if (responseData.containsKey('accessToken')) {
        return AuthResult(
          user: UserModel.fromJson(
            responseData['user'] as Map<String, dynamic>,
          ),
          accessToken: responseData['accessToken'] as String,
          refreshToken: responseData['refreshToken'] as String,
        );
      }

      // Jika register hanya mengembalikan user data saja
      return AuthResult(
        user: UserModel.fromJson(responseData),
        accessToken: '',
        refreshToken: '',
      );
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            e.message ??
            'Registrasi gagal',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get(ApiConstants.userProfile);
      return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            e.message ??
            'Gagal mendapatkan profil',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> updateFcmToken(String token) async {
    try {
      await dio.put(ApiConstants.fcmToken, data: {'fcm_token': token});
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            e.message ??
            'Gagal mengupdate FCM token',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
