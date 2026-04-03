import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

/// State untuk Auth Cubit.
///
/// Menggunakan sealed class pattern agar exhaustive di switch statement.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// State awal.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Sedang loading (login/register).
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Berhasil autentikasi.
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Tidak terautentikasi.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Terjadi error.
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
