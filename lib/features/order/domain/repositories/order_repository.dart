import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../usecases/create_order.dart';

/// Contract abstrak untuk Order Repository.
abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder(CreateOrderParams params);

  Future<Either<Failure, List<Order>>> getUserOrders();

  Future<Either<Failure, List<Order>>> getActiveOrders();

  Future<Either<Failure, List<Order>>> getOrderHistory({int page = 1, int limit = 10});

  Future<Either<Failure, Order>> getOrderById(String id);
}
