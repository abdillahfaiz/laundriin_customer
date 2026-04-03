import '../../domain/entities/outlet.dart';

/// Model Outlet — representasi data dari API response.
class OutletModel extends Outlet {
  const OutletModel({
    super.id,
    super.name,
    super.address,
    super.latitude,
    super.longitude,
    super.distanceKm,
    super.isOpen,
    super.createdAt,
    super.updatedAt,
  });

  factory OutletModel.fromJson(Map<String, dynamic> json) {
    return OutletModel(
      id: json['id'] as String?,
      name: json['nama_outlet'] as String? ?? json['name'] as String?,
      address: json['alamat'] as String? ?? json['address'] as String?,
      latitude: json['lat'] != null
          ? double.tryParse(json['lat'].toString())
          : json['latitude'] != null
              ? double.tryParse(json['latitude'].toString())
              : null,
      longitude: json['lng'] != null
          ? double.tryParse(json['lng'].toString())
          : json['longitude'] != null
              ? double.tryParse(json['longitude'].toString())
              : null,
      distanceKm: json['jarak_km'] != null
          ? double.tryParse(json['jarak_km'].toString())
          : null,
      isOpen: json['is_buka'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_outlet': name,
      'alamat': address,
      'lat': latitude,
      'lng': longitude,
      'jarak_km': distanceKm,
      'is_buka': isOpen,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
