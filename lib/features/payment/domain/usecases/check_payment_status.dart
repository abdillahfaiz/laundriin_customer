import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/payment_repository.dart';

/// UseCase untuk mengecek status pembayaran.
class CheckPaymentStatus implements UseCase<void, CheckPaymentStatusParams> {
  final PaymentRepository repository;

  const CheckPaymentStatus(this.repository);

  @override
  Future<Either<Failure, void>> call(CheckPaymentStatusParams params) {
    return repository.checkPaymentStatus(params.orderId);
  }
}

class CheckPaymentStatusParams extends Equatable {
  final String orderId;

  const CheckPaymentStatusParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
