import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/usecases/create_order.dart';
import '../models/order_model.dart';

/// Contract untuk order remote data source.
abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(CreateOrderParams params);

  Future<List<OrderModel>> getUserOrders();

  Future<List<OrderModel>> getActiveOrders();

  Future<List<OrderModel>> getOrderHistory({int page = 1, int limit = 10});

  Future<OrderModel> getOrderById(String id);
}

/// Implementasi OrderRemoteDataSource menggunakan Dio.
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  const OrderRemoteDataSourceImpl({required this.dio});

  @override
  Future<OrderModel> createOrder(CreateOrderParams params) async {
    try {
      final Map<String, dynamic> data = {
        'outlet_id': params.outletId,
        'tipe_layanan': params.tipeLayanan,
      };

      if (params.tipeLayanan == 'per_kg') {
        data['jenis_layanan_id'] = params.jenisLayananId;
        data['durasi_layanan_id'] = params.durasiLayananId;
        if (params.parfumId != null) data['parfum_id'] = params.parfumId;
        if (params.specialNotes != null)
          data['special_notes'] = params.specialNotes;
      } else if (params.tipeLayanan == 'per_item') {
        if (params.parfumId != null) data['parfum_id'] = params.parfumId;
        if (params.specialNotes != null)
          data['special_notes'] = params.specialNotes;
        if (params.items != null) {
          data['items'] = params.items!.map((e) => e.toJson()).toList();
        }
      }

      data['jenis_order'] = params.jenisOrder;

      final response = await dio.post(ApiConstants.orders, data: data);
      return OrderModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ?? 'Gagal membuat order',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<OrderModel>> getUserOrders() async {
    try {
      final response = await dio.get(ApiConstants.orders);
      final list = response.data['data'] as List;
      return list
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ?? 'Gagal memuat order',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<OrderModel>> getActiveOrders() async {
    try {
      final response = await dio.get(ApiConstants.activeOrders);
      final list = response.data['data'] as List;
      return list
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memuat active order',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<OrderModel>> getOrderHistory({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get(
        ApiConstants.orderHistory,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      final list = response.data['data'] as List;
      return list
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memuat order history',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    try {
      final response = await dio.get('${ApiConstants.orders}/$id');
      return OrderModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memuat detail order',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
