import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_auth_status.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/update_fcm_token.dart';
import 'auth_state.dart';

/// Cubit untuk mengelola state autentikasi.
///
/// Mengikuti prinsip **Single Responsibility** — hanya mengelola
/// auth state berdasarkan hasil UseCase.
///
/// Mengikuti prinsip **Dependency Inversion** — bergantung pada
/// abstraksi UseCase, bukan implementasi konkret.
class AuthCubit extends Cubit<AuthState> {
  final Login loginUseCase;
  final Register registerUseCase;
  final CheckAuthStatus checkAuthStatusUseCase;
  final UpdateFcmToken updateFcmTokenUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.checkAuthStatusUseCase,
    required this.updateFcmTokenUseCase,
  }) : super(const AuthInitial());

  /// Mengecek status autentikasi saat aplikasi pertama dibuka.
  ///
  /// Jika token tersimpan dan valid → [AuthAuthenticated].
  /// Jika tidak ada token atau token expired → [AuthUnauthenticated].
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());

    final result = await checkAuthStatusUseCase(NoParams());

    result.fold((failure) => emit(const AuthUnauthenticated()), (user) {
      emit(AuthAuthenticated(user: user));
      _updateFcmToken();
    });
  }

  /// Melakukan login.
  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      LoginParams(phoneNumber: phoneNumber, password: password),
    );

    result.fold((failure) => emit(AuthError(message: failure.message)), (user) {
      emit(AuthAuthenticated(user: user));
      _updateFcmToken();
    });
  }

  /// Melakukan registrasi.
  Future<void> register({
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    emit(const AuthLoading());

    final result = await registerUseCase(
      RegisterParams(name: name, phoneNumber: phoneNumber, password: password),
    );

    result.fold((failure) => emit(AuthError(message: failure.message)), (user) {
      emit(AuthAuthenticated(user: user));
      _updateFcmToken();
    });
  }

  /// Melakukan logout.
  void logout() {
    emit(const AuthUnauthenticated());
  }

  Future<void> _updateFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await updateFcmTokenUseCase(token);
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        updateFcmTokenUseCase(newToken);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting or updating FCM token: $e');
      }
    }
  }
}
