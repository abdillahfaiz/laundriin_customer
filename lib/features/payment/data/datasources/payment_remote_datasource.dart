import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/payment_model.dart';

/// Contract untuk payment remote data source.
abstract class PaymentRemoteDataSource {
  Future<PaymentModel> createPayment({
    required String orderId,
    required String metodePembayaran,
  });
  Future<PaymentModel> getPaymentByOrderId(String orderId);
  Future<void> checkPaymentStatus(String orderId);
}

/// Implementasi PaymentRemoteDataSource menggunakan Dio.
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  const PaymentRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaymentModel> createPayment({
    required String orderId,
    required String metodePembayaran,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstants.orders}/$orderId/payment',
        data: {'metode_pembayaran': metodePembayaran},
      );
      return PaymentModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal membuat pembayaran',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<PaymentModel> getPaymentByOrderId(String orderId) async {
    try {
      final response = await dio.get('${ApiConstants.orders}/$orderId/payment');
      return PaymentModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memuat pembayaran',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> checkPaymentStatus(String orderId) async {
    try {
      await dio.post('${ApiConstants.orders}/$orderId/payment/check');
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memeriksa status pembayaran',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
