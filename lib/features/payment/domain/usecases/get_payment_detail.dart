import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

/// UseCase untuk mengambil detail pembayaran.
class GetPaymentDetail implements UseCase<Payment, GetPaymentDetailParams> {
  final PaymentRepository repository;

  const GetPaymentDetail(this.repository);

  @override
  Future<Either<Failure, Payment>> call(GetPaymentDetailParams params) {
    return repository.getPaymentByOrderId(params.orderId);
  }
}

class GetPaymentDetailParams extends Equatable {
  final String orderId;

  const GetPaymentDetailParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
