import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/get_active_orders.dart';
import '../../domain/usecases/get_order_detail.dart';
import '../../domain/usecases/get_order_history.dart';
import '../../domain/usecases/get_user_orders.dart';
import 'order_state.dart';

/// Cubit untuk mengelola state order.
class OrderCubit extends Cubit<OrderState> {
  final CreateOrder createOrderUseCase;
  final GetUserOrders getUserOrdersUseCase;
  final GetActiveOrders getActiveOrdersUseCase;
  final GetOrderDetail getOrderDetailUseCase;
  final GetOrderHistory getOrderHistoryUseCase;

  OrderCubit({
    required this.createOrderUseCase,
    required this.getUserOrdersUseCase,
    required this.getActiveOrdersUseCase,
    required this.getOrderDetailUseCase,
    required this.getOrderHistoryUseCase,
  }) : super(const OrderInitial());

  /// Membuat order baru.
  Future<void> createOrder(CreateOrderParams params) async {
    emit(const OrderLoading());

    final result = await createOrderUseCase(params);

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) => emit(OrderCreated(order: order)),
    );
  }

  /// Mendapatkan daftar order user.
  Future<void> fetchUserOrders() async {
    emit(const OrderLoading());

    final result = await getUserOrdersUseCase(NoParams());

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (orders) => emit(OrderListLoaded(orders: orders)),
    );
  }

  /// Mendapatkan daftar active order user.
  Future<void> fetchActiveOrders() async {
    emit(const OrderLoading());

    final result = await getActiveOrdersUseCase(NoParams());

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (orders) => emit(OrderActiveLoaded(activeOrders: orders)),
    );
  }

  /// Mendapatkan detail order.
  Future<void> fetchOrderDetail(String orderId) async {
    emit(const OrderLoading());

    final result = await getOrderDetailUseCase(orderId);

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) => emit(OrderDetailLoaded(order: order)),
    );
  }

  /// Mendapatkan histori order.
  Future<void> fetchOrderHistory({int page = 1, int limit = 10}) async {
    emit(const OrderLoading());

    final result = await getOrderHistoryUseCase(GetOrderHistoryParams(page: page, limit: limit));

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (orders) => emit(OrderHistoryLoaded(orders: orders)),
    );
  }
}
