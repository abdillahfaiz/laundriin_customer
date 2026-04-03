import 'package:equatable/equatable.dart';

/// Base class untuk Failure (digunakan dengan Either pattern dari dartz).
///
/// Mengikuti prinsip **Open/Closed** — class ini bisa di-extend
/// tanpa memodifikasi kode yang sudah ada.
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Failure saat terjadi error dari server/API.
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Failure saat terjadi error dari cache/local storage.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Failure saat tidak ada koneksi internet.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Tidak ada koneksi internet'});
}
