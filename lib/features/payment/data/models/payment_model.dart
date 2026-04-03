import '../../domain/entities/payment.dart';

/// Model Payment — representasi data dari API response.
class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.orderId,
    super.midtransOrderId,
    super.paymentMethod,
    super.vaNumber,
    super.qrisUrl,
    required super.grossAmount,
    required super.status,
    super.paymentExpiredAt,
    super.paidAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      midtransOrderId: json['midtrans_order_id'] as String?,
      paymentMethod: json['metode_pembayaran'] as String?,
      vaNumber: json['va_number'] as String?,
      qrisUrl: json['qris_url'] as String?,
      grossAmount: double.parse(json['total_bayar'].toString()),
      status: json['status'] as String,
      paymentExpiredAt: json['expired_at'] != null
          ? DateTime.parse(json['expired_at'] as String)
          : null,
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'midtrans_order_id': midtransOrderId,
      'metode_pembayaran': paymentMethod,
      'va_number': vaNumber,
      'qris_url': qrisUrl,
      'total_bayar': grossAmount,
      'status': status,
      'expired_at': paymentExpiredAt?.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
