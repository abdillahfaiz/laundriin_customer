import 'package:equatable/equatable.dart';

/// Entity User — representasi data user di domain layer.
///
/// Entity hanya berisi data yang diperlukan oleh business logic,
/// tanpa detail serialization atau framework.
class User extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    phoneNumber,
    role,
    createdAt,
    updatedAt,
  ];
}
