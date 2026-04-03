import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

/// UseCase untuk membuat order baru.
class CreateOrder implements UseCase<Order, CreateOrderParams> {
  final OrderRepository repository;

  const CreateOrder(this.repository);

  @override
  Future<Either<Failure, Order>> call(CreateOrderParams params) {
    return repository.createOrder(params);
  }
}

class CreateOrderItemParam extends Equatable {
  final String itemLayananId;
  final String durasiLayananId;
  final int qty;

  const CreateOrderItemParam({
    required this.itemLayananId,
    required this.durasiLayananId,
    required this.qty,
  });

  Map<String, dynamic> toJson() => {
    'item_layanan_id': itemLayananId,
    'durasi_layanan_id': durasiLayananId,
    'qty': qty,
  };

  @override
  List<Object?> get props => [itemLayananId, durasiLayananId, qty];
}

class CreateOrderParams extends Equatable {
  final String outletId;
  final String tipeLayanan;
  final String? jenisLayananId;
  final String? durasiLayananId;
  final String? parfumId;
  final String? specialNotes;
  final List<CreateOrderItemParam>? items;
  final String jenisOrder;

  const CreateOrderParams({
    required this.outletId,
    required this.tipeLayanan,
    this.jenisLayananId,
    this.durasiLayananId,
    this.parfumId,
    this.specialNotes,
    this.items,
    required this.jenisOrder,
  });

  @override
  List<Object?> get props => [
    outletId,
    tipeLayanan,
    jenisLayananId,
    durasiLayananId,
    parfumId,
    specialNotes,
    items,
    jenisOrder,
  ];
}
