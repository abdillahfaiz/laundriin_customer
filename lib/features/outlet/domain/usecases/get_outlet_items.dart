import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/outlet_item.dart';
import '../repositories/outlet_repository.dart';

/// UseCase untuk mendapatkan item layanan per-item dari outlet.
class GetOutletItemsPerItem implements UseCase<List<OutletItem>, String> {
  final OutletRepository repository;

  const GetOutletItemsPerItem(this.repository);

  @override
  Future<Either<Failure, List<OutletItem>>> call(String outletId) {
    return repository.getOutletItemsPerItem(outletId);
  }
}
