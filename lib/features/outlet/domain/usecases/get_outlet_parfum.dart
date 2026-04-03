import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/outlet_parfum.dart';
import '../repositories/outlet_repository.dart';

class GetOutletParfum implements UseCase<List<OutletParfum>, String> {
  final OutletRepository repository;

  const GetOutletParfum(this.repository);

  @override
  Future<Either<Failure, List<OutletParfum>>> call(String outletId) {
    return repository.getOutletParfum(outletId);
  }
}
