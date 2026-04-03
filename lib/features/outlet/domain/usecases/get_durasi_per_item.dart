import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/outlet_durasi.dart';
import '../repositories/outlet_repository.dart';

/// UseCase untuk mendapatkan durasi per-item berdasarkan jenis.
class GetDurasiPerItem
    implements UseCase<List<OutletDurasi>, GetDurasiPerItemParams> {
  final OutletRepository repository;

  const GetDurasiPerItem(this.repository);

  @override
  Future<Either<Failure, List<OutletDurasi>>> call(
    GetDurasiPerItemParams params,
  ) {
    return repository.getDurasiPerItem(params.outletId, params.jenisPerItemId);
  }
}

class GetDurasiPerItemParams extends Equatable {
  final String outletId;
  final String jenisPerItemId;

  const GetDurasiPerItemParams({
    required this.outletId,
    required this.jenisPerItemId,
  });

  @override
  List<Object?> get props => [outletId, jenisPerItemId];
}
