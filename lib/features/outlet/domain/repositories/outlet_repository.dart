import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/outlet.dart';
import '../entities/outlet_coverage.dart';
import '../entities/outlet_durasi.dart';
import '../entities/outlet_item.dart';
import '../entities/outlet_jenis_per_item.dart';
import '../entities/outlet_layanan.dart';
import '../entities/outlet_parfum.dart';

/// Contract abstrak untuk Outlet Repository.
abstract class OutletRepository {
  /// Get Nearby Outlets
  Future<Either<Failure, List<Outlet>>> getNearbyOutlets({
    required double latitude,
    required double longitude,
    double? radius,
    int? page,
    int? limit,
  });

  /// Get Outlet Detail
  Future<Either<Failure, Outlet>> getOutletById(String outletId);

  /// Check Coverage Area
  Future<Either<Failure, OutletCoverage>> checkCoverageArea({
    required String outletId,
    required double latitude,
    required double longitude,
  });

  /// Get Parfum by Outlet
  Future<Either<Failure, List<OutletParfum>>> getOutletParfum(String outletId);

  /// Get Layanan Per KG
  Future<Either<Failure, List<OutletLayanan>>> getOutletLayananPerKg(
    String outletId,
  );

  /// Get Durasi Per KG by Jenis
  Future<Either<Failure, List<OutletDurasi>>> getOutletDurasiPerKg(
    String outletId,
    String jenisLayananId,
  );

  /// Get Items Per Item
  Future<Either<Failure, List<OutletItem>>> getOutletItemsPerItem(
    String outletId,
  );

  /// Get Jenis by Item
  Future<Either<Failure, List<OutletJenisPerItem>>> getJenisByItem(
    String outletId,
    String itemLayananId,
  );

  /// Get Durasi Per Item by Jenis
  Future<Either<Failure, List<OutletDurasi>>> getDurasiPerItem(
    String outletId,
    String jenisPerItemId,
  );
}
