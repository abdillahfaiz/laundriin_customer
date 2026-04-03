import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/payment.dart';

/// Contract abstrak untuk Payment Repository.
abstract class PaymentRepository {
  Future<Either<Failure, Payment>> createPayment({
    required String orderId,
    required String metodePembayaran,
  });

  Future<Either<Failure, Payment>> getPaymentByOrderId(String orderId);

  Future<Either<Failure, void>> checkPaymentStatus(String orderId);
}
