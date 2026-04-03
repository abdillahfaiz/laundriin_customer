import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

/// UseCase untuk membuat pembayaran.
class CreatePayment implements UseCase<Payment, CreatePaymentParams> {
  final PaymentRepository repository;

  const CreatePayment(this.repository);

  @override
  Future<Either<Failure, Payment>> call(CreatePaymentParams params) {
    return repository.createPayment(
      orderId: params.orderId,
      metodePembayaran: params.metodePembayaran,
    );
  }
}

class CreatePaymentParams extends Equatable {
  final String orderId;
  final String metodePembayaran;

  const CreatePaymentParams({
    required this.orderId,
    required this.metodePembayaran,
  });

  @override
  List<Object?> get props => [orderId, metodePembayaran];
}
