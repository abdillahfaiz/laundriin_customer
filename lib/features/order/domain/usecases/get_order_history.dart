import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrderHistory implements UseCase<List<Order>, GetOrderHistoryParams> {
  final OrderRepository repository;

  GetOrderHistory(this.repository);

  @override
  Future<Either<Failure, List<Order>>> call(GetOrderHistoryParams params) async {
    return await repository.getOrderHistory(page: params.page, limit: params.limit);
  }
}

class GetOrderHistoryParams {
  final int page;
  final int limit;

  const GetOrderHistoryParams({this.page = 1, this.limit = 10});
}
