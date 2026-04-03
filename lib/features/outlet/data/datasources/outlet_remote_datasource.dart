import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/outlet_coverage_model.dart';
import '../models/outlet_durasi_model.dart';
import '../models/outlet_item_model.dart';
import '../models/outlet_jenis_per_item_model.dart';
import '../models/outlet_layanan_model.dart';
import '../models/outlet_model.dart';
import '../models/outlet_parfum_model.dart';

/// Contract untuk outlet remote data source.
abstract class OutletRemoteDataSource {
  /// GET /customer/outlets/nearby?lat&lng&radius&page&limit
  Future<List<OutletModel>> getNearbyOutlets({
    required double latitude,
    required double longitude,
    double? radius,
    int? page,
    int? limit,
  });

  /// GET /customer/outlets/{outletId}
  Future<OutletModel> getOutletById(String outletId);

  /// GET /customer/outlets/{outletId}/coverage?lat&lng
  Future<OutletCoverageModel> checkCoverageArea({
    required String outletId,
    required double latitude,
    required double longitude,
  });

  /// GET /customer/outlets/{outletId}/parfum
  Future<List<OutletParfumModel>> getOutletParfum(String outletId);

  /// GET /customer/outlets/{outletId}/layanan/per-kg
  Future<List<OutletLayananModel>> getOutletLayananPerKg(String outletId);

  /// GET /customer/outlets/{outletId}/layanan/per-kg/{jenisLayananId}/durasi
  Future<List<OutletDurasiModel>> getOutletDurasiPerKg(
    String outletId,
    String jenisLayananId,
  );

  /// GET /customer/outlets/{outletId}/layanan/per-item/items
  Future<List<OutletItemModel>> getOutletItemsPerItem(String outletId);

  /// GET /customer/outlets/{outletId}/layanan/per-item/items/{itemLayananId}/jenis
  Future<List<OutletJenisPerItemModel>> getJenisByItem(
    String outletId,
    String itemLayananId,
  );

  /// GET /customer/outlets/{outletId}/layanan/per-item/jenis/{jenisPerItemId}/durasi
  Future<List<OutletDurasiModel>> getDurasiPerItem(
    String outletId,
    String jenisPerItemId,
  );
}

/// Implementasi OutletRemoteDataSource menggunakan Dio.
class OutletRemoteDataSourceImpl implements OutletRemoteDataSource {
  final Dio dio;

  const OutletRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<OutletModel>> getNearbyOutlets({
    required double latitude,
    required double longitude,
    double? radius,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'lat': latitude,
        'lng': longitude,
      };
      if (radius != null) queryParameters['radius'] = radius;
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await dio.get(
        ApiConstants.nearbyOutlets,
        queryParameters: queryParameters,
      );
      final list = response.data['data'] as List;
      return list
          .map((e) => OutletModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ?? 'Gagal memuat outlet',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<OutletModel> getOutletById(String outletId) async {
    try {
      final response = await dio.get(ApiConstants.outletDetail(outletId));
      return OutletModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memuat detail outlet',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<OutletCoverageModel> checkCoverageArea({
    required String outletId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.outletCoverage(outletId),
        queryParameters: {'lat': latitude, 'lng': longitude},
      );
      return OutletCoverageModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal mengecek area cakupan outlet',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<OutletParfumModel>> getOutletParfum(String outletId) async {
    try {
      final response = await dio.get(ApiConstants.outletParfum(outletId));
      final list = response.data['data'] as List;
      return list
          .map((e) => OutletParfumModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memuat pilihan parfum dari outlet',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<OutletLayananModel>> getOutletLayananPerKg(
    String outletId,
  ) async {
    try {
      final response = await dio.get(ApiConstants.outletLayananPerKg(outletId));
      final list = response.data['data'] as List;
      return list
          .map((e) => OutletLayananModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memuat jenis layanan per-kg outlet',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<OutletDurasiModel>> getOutletDurasiPerKg(
    String outletId,
    String jenisLayananId,
  ) async {
    try {
      final response = await dio.get(
        ApiConstants.outletDurasiPerKg(outletId, jenisLayananId),
      );
      final list = response.data['data'] as List;
      return list
          .map((e) => OutletDurasiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memuat pilihan durasi layanan per-kg',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<OutletItemModel>> getOutletItemsPerItem(String outletId) async {
    try {
      final response = await dio.get(
        ApiConstants.outletItemsPerItem(outletId),
      );
      final list = response.data['data'] as List;
      return list
          .map((e) => OutletItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memuat item layanan per-item outlet',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<OutletJenisPerItemModel>> getJenisByItem(
    String outletId,
    String itemLayananId,
  ) async {
    try {
      final response = await dio.get(
        ApiConstants.outletJenisByItem(outletId, itemLayananId),
      );
      final list = response.data['data'] as List;
      return list
          .map(
            (e) =>
                OutletJenisPerItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memuat jenis layanan per-item',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<OutletDurasiModel>> getDurasiPerItem(
    String outletId,
    String jenisPerItemId,
  ) async {
    try {
      final response = await dio.get(
        ApiConstants.outletDurasiPerItem(outletId, jenisPerItemId),
      );
      final list = response.data['data'] as List;
      return list
          .map((e) => OutletDurasiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            'Gagal memuat durasi layanan per-item',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
