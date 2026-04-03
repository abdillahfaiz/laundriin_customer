import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/outlet_durasi.dart';
import '../repositories/outlet_repository.dart';

/// UseCase untuk mendapatkan durasi per-KG berdasarkan jenis layanan.
class GetOutletDurasiPerKg
    implements UseCase<List<OutletDurasi>, GetOutletDurasiPerKgParams> {
  final OutletRepository repository;

  const GetOutletDurasiPerKg(this.repository);

  @override
  Future<Either<Failure, List<OutletDurasi>>> call(
    GetOutletDurasiPerKgParams params,
  ) {
    return repository.getOutletDurasiPerKg(
      params.outletId,
      params.jenisLayananId,
    );
  }
}

class GetOutletDurasiPerKgParams {
  final String outletId;
  final String jenisLayananId;

  const GetOutletDurasiPerKgParams({
    required this.outletId,
    required this.jenisLayananId,
  });
}
