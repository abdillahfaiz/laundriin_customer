import 'package:equatable/equatable.dart';

/// Entity Outlet — representasi outlet laundry di domain layer.
class Outlet extends Equatable {
  final String? id;
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;
  final bool? isOpen;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Outlet({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.distanceKm,
    this.isOpen,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    latitude,
    longitude,
    distanceKm,
    isOpen,
  ];
}
