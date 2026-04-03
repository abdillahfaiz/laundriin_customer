import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/outlet.dart';
import '../repositories/outlet_repository.dart';

/// UseCase untuk mendapatkan daftar outlet terdekat.
class GetNearbyOutlets implements UseCase<List<Outlet>, NearbyOutletsParams> {
  final OutletRepository repository;

  const GetNearbyOutlets(this.repository);

  @override
  Future<Either<Failure, List<Outlet>>> call(NearbyOutletsParams params) {
    return repository.getNearbyOutlets(
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
      page: params.page,
      limit: params.limit,
    );
  }
}

class NearbyOutletsParams extends Equatable {
  final double latitude;
  final double longitude;
  final double? radius;
  final int? page;
  final int? limit;

  const NearbyOutletsParams({
    required this.latitude,
    required this.longitude,
    this.radius,
    this.page,
    this.limit,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius, page, limit];
}
