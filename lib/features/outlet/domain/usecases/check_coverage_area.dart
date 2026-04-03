import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/outlet_coverage.dart';
import '../repositories/outlet_repository.dart';

/// UseCase untuk mengecek apakah lokasi customer tercakup oleh outlet.
class CheckCoverageArea
    implements UseCase<OutletCoverage, CheckCoverageAreaParams> {
  final OutletRepository repository;

  const CheckCoverageArea(this.repository);

  @override
  Future<Either<Failure, OutletCoverage>> call(
    CheckCoverageAreaParams params,
  ) {
    return repository.checkCoverageArea(
      outletId: params.outletId,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class CheckCoverageAreaParams extends Equatable {
  final String outletId;
  final double latitude;
  final double longitude;

  const CheckCoverageAreaParams({
    required this.outletId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [outletId, latitude, longitude];
}
