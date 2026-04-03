import 'package:equatable/equatable.dart';

import '../../domain/entities/order.dart';

/// State untuk Order Cubit.
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderCreated extends OrderState {
  final Order order;

  const OrderCreated({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderListLoaded extends OrderState {
  final List<Order> orders;

  const OrderListLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrderActiveLoaded extends OrderState {
  final List<Order> activeOrders;

  const OrderActiveLoaded({required this.activeOrders});

  @override
  List<Object?> get props => [activeOrders];
}

class OrderHistoryLoaded extends OrderState {
  final List<Order> orders;

  const OrderHistoryLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrderDetailLoaded extends OrderState {
  final Order order;

  const OrderDetailLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object?> get props => [message];
}
