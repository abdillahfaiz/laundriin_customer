import 'package:equatable/equatable.dart';

/// Entity Order — representasi order laundry di domain layer.
class Order extends Equatable {
  final String? id;
  final String? userId;
  final String? outletId;
  final String? serviceId;
  final String? dropQrCode;
  final int? estimatedBags;
  final String? specialNotes;
  final double? actualWeight;
  final String? weightProofUrl;
  final double? totalPrice;
  final String? orderStatus;
  final String? pickupQrCode;

  // Extra fields from active orders list & details
  final String? transactionId;
  final String? outletName;
  final String? serviceName;
  final String? durasiName;
  final String? parfumName;
  final String? paymentStatus;
  final OrderPayment? payment;
  final List<StatusLog>? statusLogs;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Order({
    this.id,
    this.userId,
    this.outletId,
    this.serviceId,
    this.dropQrCode,
    this.estimatedBags,
    this.specialNotes,
    this.actualWeight,
    this.weightProofUrl,
    this.totalPrice,
    this.orderStatus,
    this.pickupQrCode,
    this.transactionId,
    this.outletName,
    this.serviceName,
    this.durasiName,
    this.parfumName,
    this.paymentStatus,
    this.payment,
    this.statusLogs,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    outletId,
    serviceId,
    orderStatus,
    transactionId,
    outletName,
    serviceName,
    durasiName,
    parfumName,
    paymentStatus,
    payment,
    statusLogs,
    actualWeight,
    totalPrice,
    updatedAt,
  ];
}

class StatusLog extends Equatable {
  final String? id;
  final String? orderId;
  final String? status;
  final String? note;
  final DateTime? createdAt;

  const StatusLog({
    this.id,
    this.orderId,
    this.status,
    this.note,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, orderId, status, note, createdAt];
}

class OrderPayment extends Equatable {
  final String? id;
  final String? orderId;
  final String? midtransOrderId;
  final String? paymentMethod;
  final String? vaNumber;
  final String? qrisUrl;
  final double? grossAmount;
  final String? status;
  final DateTime? paymentExpiredAt;
  final DateTime? paidAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderPayment({
    this.id,
    this.orderId,
    this.midtransOrderId,
    this.paymentMethod,
    this.vaNumber,
    this.qrisUrl,
    this.grossAmount,
    this.status,
    this.paymentExpiredAt,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    midtransOrderId,
    paymentMethod,
    vaNumber,
    qrisUrl,
    grossAmount,
    status,
    paymentExpiredAt,
    paidAt,
    updatedAt,
  ];
}
