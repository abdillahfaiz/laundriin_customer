import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrderDetail implements UseCase<Order, String> {
  final OrderRepository repository;

  GetOrderDetail(this.repository);

  @override
  Future<Either<Failure, Order>> call(String orderId) async {
    return await repository.getOrderById(orderId);
  }
}
