import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraksi untuk cek koneksi internet.
///
/// Mengikuti prinsip **Dependency Inversion** — kode yang bergantung
/// pada NetworkInfo hanya tahu interface, bukan implementasi.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementasi NetworkInfo menggunakan connectivity_plus.
///
/// Mengikuti prinsip **Liskov Substitution** — bisa menggantikan
/// NetworkInfo di mana saja tanpa mengubah behavior.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  const NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
