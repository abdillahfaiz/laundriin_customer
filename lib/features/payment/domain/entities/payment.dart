import 'package:equatable/equatable.dart';

/// Entity Payment — representasi pembayaran di domain layer.
class Payment extends Equatable {
  final String id;
  final String orderId;
  final String? midtransOrderId;
  final String? paymentMethod;
  final String? vaNumber;
  final String? qrisUrl;
  final double grossAmount;
  final String status;
  final DateTime? paymentExpiredAt;
  final DateTime? paidAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payment({
    required this.id,
    required this.orderId,
    this.midtransOrderId,
    this.paymentMethod,
    this.vaNumber,
    this.qrisUrl,
    required this.grossAmount,
    required this.status,
    this.paymentExpiredAt,
    this.paidAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, orderId, status, grossAmount];
}
