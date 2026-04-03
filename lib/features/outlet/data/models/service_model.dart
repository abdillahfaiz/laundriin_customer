import '../../domain/entities/service.dart';

/// Model Service — representasi data dari API response.
class ServiceModel extends Service {
  const ServiceModel({
    super.id,
    super.outletId,
    super.name,
    super.type,
    super.price,
    super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String?,
      outletId: json['outlet_id'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outlet_id': outletId,
      'name': name,
      'type': type,
      'price': price,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
