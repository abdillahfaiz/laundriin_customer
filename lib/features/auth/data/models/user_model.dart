import '../../domain/entities/user.dart';

/// Model User — representasi data dari API response.
///
/// Mengikuti prinsip **Single Responsibility** — bertanggung jawab
/// untuk serialization/deserialization saja.
///
/// Mendukung field API response yang menggunakan bahasa Indonesia
/// maupun bahasa Inggris untuk backward compatibility.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.role,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Factory constructor dari JSON.
  ///
  /// Mendukung variasi key dari API:
  /// - `nama` / `name`
  /// - `nomor_telepon` / `phone_number`
  /// - `created_at` / `createdAt`
  /// - `updated_at` / `updatedAt`
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: (json['nama'] ?? json['name'] ?? '') as String,
      phoneNumber:
          (json['nomor_telepon'] ?? json['phone_number'] ?? '') as String,
      role: (json['role'] ?? '') as String,
      createdAt: _parseDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: _parseDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  /// Helper untuk parse DateTime yang fleksibel.
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  /// Konversi ke JSON (untuk caching ke SharedPreferences).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': name,
      'nomor_telepon': phoneNumber,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
