import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';

/// Konfigurasi Dio HTTP client dengan interceptor untuk auth token.
///
/// Mengikuti prinsip **Single Responsibility** — class ini hanya
/// bertanggung jawab untuk konfigurasi HTTP client.
class ApiClient {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  ApiClient({required this.dio, required this.sharedPreferences}) {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sharedPreferences.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401 &&
              error.response?.data?['message'] == 'Token sudah expired') {
            final refreshToken = sharedPreferences.getString('refresh_token');
            if (refreshToken != null) {
              try {
                final refreshDio = Dio(dio.options);
                final response = await refreshDio.post(
                  ApiConstants.refreshToken,
                  data: {
                    'refresh_token': refreshToken,
                  }, // sesuaikan key payload jika backend menggunakan format beda
                );

                if (response.statusCode == 200 || response.statusCode == 201) {
                  final newAccessToken = response.data['data']['accessToken'];
                  final newRefreshToken = response.data['data']['refreshToken'];

                  await sharedPreferences.setString(
                    'access_token',
                    newAccessToken,
                  );
                  if (newRefreshToken != null) {
                    await sharedPreferences.setString(
                      'refresh_token',
                      newRefreshToken,
                    );
                  }

                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newAccessToken';

                  // Ulangi permintaan yang gagal dengan token baru
                  final cloneReq = await refreshDio.fetch(options);
                  return handler.resolve(cloneReq);
                }
              } catch (e) {
                // Refresh token gagal atau expired juga
                await sharedPreferences.remove('access_token');
                await sharedPreferences.remove('refresh_token');
                await sharedPreferences.remove('cached_user');
                // Reject error awal
                return handler.next(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
}
