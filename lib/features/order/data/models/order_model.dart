import '../../domain/entities/order.dart';

/// Model Order — representasi data dari API response.
class OrderModel extends Order {
  const OrderModel({
    super.id,
    super.userId,
    super.outletId,
    super.serviceId,
    super.dropQrCode,
    super.estimatedBags,
    super.specialNotes,
    super.actualWeight,
    super.weightProofUrl,
    super.totalPrice,
    super.orderStatus,
    super.pickupQrCode,
    super.transactionId,
    super.outletName,
    super.serviceName,
    super.durasiName,
    super.parfumName,
    super.paymentStatus,
    super.payment,
    super.statusLogs,
    super.createdAt,
    super.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString(),
      userId: (json['customer_id'] ?? json['user_id'])?.toString(),
      outletId: json['outlet_id']?.toString(),
      serviceId: (json['jenis_layanan_id'] ?? json['service_id'])?.toString(),
      dropQrCode: (json['qr_code'] ?? json['drop_qr_code'])?.toString(),
      estimatedBags: json['berat_estimasi'] != null
          ? int.tryParse(json['berat_estimasi'].toString())
          : (json['estimated_bags'] != null
                ? int.tryParse(json['estimated_bags'].toString())
                : null),
      specialNotes: json['special_notes'] as String?,
      actualWeight: json['berat_aktual'] != null
          ? double.tryParse(json['berat_aktual'].toString())
          : (json['actual_weight'] != null
                ? double.tryParse(json['actual_weight'].toString())
                : null),
      weightProofUrl:
          (json['foto_timbangan'] ?? json['weight_proof_url']) as String?,
      totalPrice: json['total_price'] != null
          ? double.tryParse(json['total_price'].toString())
          : (json['total_harga_final'] != null
                ? double.tryParse(json['total_harga_final'].toString())
                : null),
      orderStatus:
          (json['status'] ?? json['order_status']) as String?,
      pickupQrCode: (json['qr_code'] ?? json['pickup_qr_code']) as String?,

      transactionId: json['transaction_id'] as String?,
      outletName: json['outlet']?['nama_outlet'] as String?,
      serviceName: json['jenis_layanan']?['nama'] as String?,
      durasiName: json['durasi_layanan']?['nama'] as String?,
      parfumName: json['parfum']?['nama'] as String?,
      paymentStatus: json['payment']?['status'] as String?,
      payment: json['payment'] != null
          ? OrderPaymentModel.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
      statusLogs: (json['status_logs'] as List<dynamic>?)
          ?.map((e) => StatusLogModel.fromJson(e as Map<String, dynamic>))
          .toList(),

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
      'user_id': userId,
      'outlet_id': outletId,
      'service_id': serviceId,
      'drop_qr_code': dropQrCode,
      'estimated_bags': estimatedBags,
      'special_notes': specialNotes,
      'actual_weight': actualWeight,
      'weight_proof_url': weightProofUrl,
      'total_price': totalPrice,
      'order_status': orderStatus,
      'pickup_qr_code': pickupQrCode,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class StatusLogModel extends StatusLog {
  const StatusLogModel({
    super.id,
    super.orderId,
    super.status,
    super.note,
    super.createdAt,
  });

  factory StatusLogModel.fromJson(Map<String, dynamic> json) {
    return StatusLogModel(
      id: json['id']?.toString(),
      orderId: json['order_id']?.toString(),
      status: json['status']?.toString(),
      note: json['note']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}

class OrderPaymentModel extends OrderPayment {
  const OrderPaymentModel({
    super.id,
    super.orderId,
    super.midtransOrderId,
    super.paymentMethod,
    super.vaNumber,
    super.qrisUrl,
    super.grossAmount,
    super.status,
    super.paymentExpiredAt,
    super.paidAt,
    super.createdAt,
    super.updatedAt,
  });

  factory OrderPaymentModel.fromJson(Map<String, dynamic> json) {
    return OrderPaymentModel(
      id: json['id']?.toString(),
      orderId: json['order_id']?.toString(),
      midtransOrderId: json['midtrans_order_id'] as String?,
      paymentMethod: json['metode_pembayaran'] as String?,
      vaNumber: json['va_number'] as String?,
      qrisUrl: json['qris_url'] as String?,
      grossAmount: json['total_bayar'] != null ? double.tryParse(json['total_bayar'].toString()) : null,
      status: json['status']?.toString(),
      paymentExpiredAt: json['expired_at'] != null
          ? DateTime.tryParse(json['expired_at'].toString())
          : null,
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'].toString())
          : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
