import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/outlet_layanan.dart';
import '../repositories/outlet_repository.dart';

/// UseCase untuk mendapatkan layanan per-KG dari outlet.
class GetOutletLayananPerKg implements UseCase<List<OutletLayanan>, String> {
  final OutletRepository repository;

  const GetOutletLayananPerKg(this.repository);

  @override
  Future<Either<Failure, List<OutletLayanan>>> call(String outletId) {
    return repository.getOutletLayananPerKg(outletId);
  }
}
