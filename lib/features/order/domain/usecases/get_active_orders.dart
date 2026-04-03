import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetActiveOrders implements UseCase<List<Order>, NoParams> {
  final OrderRepository repository;

  GetActiveOrders(this.repository);

  @override
  Future<Either<Failure, List<Order>>> call(NoParams params) {
    return repository.getActiveOrders();
  }
}
