import 'dart:io';

/// Konstanta API untuk laundriin_customer
class ApiConstants {
  ApiConstants._();

  // Base URL - otomatis detect platform
  // Android emulator: 10.0.2.2 (alias ke host machine)
  // iOS simulator / desktop: localhost
  // Physical device: ganti ke IP address PC di jaringan lokal
  static final String baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    const port = '3000';
    const path = '/api/v1';

    // Jika berjalan di Android (emulator maupun device)
    if (Platform.isAndroid) {
      // return 'http://192.168.100.6:$port$path';
      // return 'http://192.168.100.6:$port$path';
      return 'https://laundriin-service-production.up.railway.app/api/v1';
    }

    // iOS simulator, desktop, dll → bisa langsung pakai localhost
    return 'https://laundriin-service-production.up.railway.app/api/v1';
  }

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register/customer';
  static const String refreshToken = '/auth/refresh-token';
  static const String fcmToken = '/auth/fcm-token';

  // User
  static const String userProfile = '/users/profile';

  // Outlets
  static const String nearbyOutlets = '/customer/outlets/nearby';
  static const String customerOutlets = '/customer/outlets';

  /// Builds: /customer/outlets/{outletId}
  static String outletDetail(String outletId) => '$customerOutlets/$outletId';

  /// Builds: /customer/outlets/{outletId}/coverage
  static String outletCoverage(String outletId) =>
      '$customerOutlets/$outletId/coverage';

  /// Builds: /customer/outlets/{outletId}/parfum
  static String outletParfum(String outletId) =>
      '$customerOutlets/$outletId/parfum';

  /// Builds: /customer/outlets/{outletId}/layanan/per-kg
  static String outletLayananPerKg(String outletId) =>
      '$customerOutlets/$outletId/layanan/per-kg';

  /// Builds: /customer/outlets/{outletId}/layanan/per-kg/{jenisLayananId}/durasi
  static String outletDurasiPerKg(String outletId, String jenisLayananId) =>
      '$customerOutlets/$outletId/layanan/per-kg/$jenisLayananId/durasi';

  /// Builds: /customer/outlets/{outletId}/layanan/per-item/items
  static String outletItemsPerItem(String outletId) =>
      '$customerOutlets/$outletId/layanan/per-item/items';

  /// Builds: /customer/outlets/{outletId}/layanan/per-item/items/{itemLayananId}/jenis
  static String outletJenisByItem(String outletId, String itemLayananId) =>
      '$customerOutlets/$outletId/layanan/per-item/items/$itemLayananId/jenis';

  /// Builds: /customer/outlets/{outletId}/layanan/per-item/jenis/{jenisPerItemId}/durasi
  static String outletDurasiPerItem(String outletId, String jenisPerItemId) =>
      '$customerOutlets/$outletId/layanan/per-item/jenis/$jenisPerItemId/durasi';

  // Orders
  static const String orders = '/customer/orders';
  static const String activeOrders = '/customer/orders/active';
  static const String orderHistory = '/customer/orders/history';

  // Payments
  static const String payments = '/payments';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
