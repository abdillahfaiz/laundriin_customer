import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/outlet.dart';
import '../../domain/entities/outlet_coverage.dart';
import '../../domain/entities/outlet_durasi.dart';
import '../../domain/entities/outlet_item.dart';
import '../../domain/entities/outlet_jenis_per_item.dart';
import '../../domain/entities/outlet_layanan.dart';
import '../../domain/entities/outlet_parfum.dart';
import '../../domain/repositories/outlet_repository.dart';
import '../datasources/outlet_remote_datasource.dart';

/// Implementasi OutletRepository.
class OutletRepositoryImpl implements OutletRepository {
  final OutletRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const OutletRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Outlet>>> getNearbyOutlets({
    required double latitude,
    required double longitude,
    double? radius,
    int? page,
    int? limit,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final outlets = await remoteDataSource.getNearbyOutlets(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        page: page,
        limit: limit,
      );
      return Right(outlets);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Outlet>> getOutletById(String outletId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final outlet = await remoteDataSource.getOutletById(outletId);
      return Right(outlet);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, OutletCoverage>> checkCoverageArea({
    required String outletId,
    required double latitude,
    required double longitude,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final coverage = await remoteDataSource.checkCoverageArea(
        outletId: outletId,
        latitude: latitude,
        longitude: longitude,
      );
      return Right(coverage);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<OutletParfum>>> getOutletParfum(
    String outletId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final parfumList = await remoteDataSource.getOutletParfum(outletId);
      return Right(parfumList);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<OutletLayanan>>> getOutletLayananPerKg(
    String outletId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final layananList =
          await remoteDataSource.getOutletLayananPerKg(outletId);
      return Right(layananList);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<OutletDurasi>>> getOutletDurasiPerKg(
    String outletId,
    String jenisLayananId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final durasiList = await remoteDataSource.getOutletDurasiPerKg(
        outletId,
        jenisLayananId,
      );
      return Right(durasiList);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<OutletItem>>> getOutletItemsPerItem(
    String outletId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final items = await remoteDataSource.getOutletItemsPerItem(outletId);
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<OutletJenisPerItem>>> getJenisByItem(
    String outletId,
    String itemLayananId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final jenisList = await remoteDataSource.getJenisByItem(
        outletId,
        itemLayananId,
      );
      return Right(jenisList);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<OutletDurasi>>> getDurasiPerItem(
    String outletId,
    String jenisPerItemId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final durasiList = await remoteDataSource.getDurasiPerItem(
        outletId,
        jenisPerItemId,
      );
      return Right(durasiList);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
