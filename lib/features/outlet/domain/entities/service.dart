import 'package:equatable/equatable.dart';

/// Entity Service — representasi layanan laundry di domain layer.
class Service extends Equatable {
  final String? id;
  final String? outletId;
  final String? name;
  final String? type; // KILOAN / SATUAN
  final double? price;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Service({
    this.id,
    this.outletId,
    this.name,
    this.type,
    this.price,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, outletId, name, type, price, isActive];
}
