import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/outlet_jenis_per_item.dart';
import '../repositories/outlet_repository.dart';

/// UseCase untuk mendapatkan jenis layanan berdasarkan item.
class GetJenisByItem
    implements UseCase<List<OutletJenisPerItem>, GetJenisByItemParams> {
  final OutletRepository repository;

  const GetJenisByItem(this.repository);

  @override
  Future<Either<Failure, List<OutletJenisPerItem>>> call(
    GetJenisByItemParams params,
  ) {
    return repository.getJenisByItem(params.outletId, params.itemLayananId);
  }
}

class GetJenisByItemParams extends Equatable {
  final String outletId;
  final String itemLayananId;

  const GetJenisByItemParams({
    required this.outletId,
    required this.itemLayananId,
  });

  @override
  List<Object?> get props => [outletId, itemLayananId];
}
