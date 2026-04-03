import 'package:dartz/dartz.dart';
import 'package:laundriin_customer/features/order/data/models/order_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/create_order.dart';
import '../datasources/order_remote_datasource.dart';

/// Implementasi OrderRepository.
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrderModel>> createOrder(
    CreateOrderParams params,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final order = await remoteDataSource.createOrder(params);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getUserOrders() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final orders = await remoteDataSource.getUserOrders();
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getActiveOrders() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final orders = await remoteDataSource.getActiveOrders();
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getOrderHistory({int page = 1, int limit = 10}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final orders = await remoteDataSource.getOrderHistory(page: page, limit: limit);
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> getOrderById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final order = await remoteDataSource.getOrderById(id);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
