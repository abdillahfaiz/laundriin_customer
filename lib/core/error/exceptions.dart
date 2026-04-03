/// Custom exception untuk error dari server/API.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() =>
      'ServerException(message: $message, statusCode: $statusCode)';
}

/// Custom exception untuk error dari cache/local storage.
class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException(message: $message)';
}

/// Custom exception untuk error jaringan.
class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'Tidak ada koneksi internet'});

  @override
  String toString() => 'NetworkException(message: $message)';
}
