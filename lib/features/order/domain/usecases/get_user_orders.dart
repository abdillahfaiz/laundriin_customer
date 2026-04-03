import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

/// UseCase untuk mendapatkan daftar order user.
class GetUserOrders implements UseCase<List<Order>, NoParams> {
  final OrderRepository repository;

  const GetUserOrders(this.repository);

  @override
  Future<Either<Failure, List<Order>>> call(NoParams params) {
    return repository.getUserOrders();
  }
}
