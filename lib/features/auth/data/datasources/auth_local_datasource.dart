import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Contract untuk auth local data source (cache).
abstract class AuthLocalDataSource {
  Future<UserModel> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> cacheTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearCache();
}

/// Implementasi AuthLocalDataSource menggunakan SharedPreferences.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _cachedUserKey = 'cached_user';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  const AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getCachedUser() {
    final jsonString = sharedPreferences.getString(_cachedUserKey);
    if (jsonString != null) {
      return Future.value(
        UserModel.fromJson(json.decode(jsonString) as Map<String, dynamic>),
      );
    }
    throw const CacheException(message: 'Data user tidak ditemukan di cache');
  }

  @override
  Future<void> cacheUser(UserModel user) {
    return sharedPreferences.setString(
      _cachedUserKey,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<void> cacheTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await sharedPreferences.setString(_accessTokenKey, accessToken);
    await sharedPreferences.setString(_refreshTokenKey, refreshToken);
  }

  @override
  Future<String?> getAccessToken() {
    return Future.value(sharedPreferences.getString(_accessTokenKey));
  }

  @override
  Future<String?> getRefreshToken() {
    return Future.value(sharedPreferences.getString(_refreshTokenKey));
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_cachedUserKey);
    await sharedPreferences.remove(_accessTokenKey);
    await sharedPreferences.remove(_refreshTokenKey);
  }
}
