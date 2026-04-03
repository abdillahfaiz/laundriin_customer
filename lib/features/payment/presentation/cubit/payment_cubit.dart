import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_payment_status.dart';
import '../../domain/usecases/create_payment.dart';
import '../../domain/usecases/get_payment_detail.dart';
import 'payment_state.dart';

/// Cubit untuk mengelola state pembayaran.
class PaymentCubit extends Cubit<PaymentState> {
  final CreatePayment createPaymentUseCase;
  final GetPaymentDetail getPaymentDetailUseCase;
  final CheckPaymentStatus checkPaymentStatusUseCase;

  PaymentCubit({
    required this.createPaymentUseCase,
    required this.getPaymentDetailUseCase,
    required this.checkPaymentStatusUseCase,
  }) : super(const PaymentInitial());

  /// Membuat pembayaran untuk order tertentu.
  Future<void> createPayment({
    required String orderId,
    required String metodePembayaran,
  }) async {
    emit(const PaymentLoading());

    final result = await createPaymentUseCase(
      CreatePaymentParams(orderId: orderId, metodePembayaran: metodePembayaran),
    );

    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (payment) => emit(PaymentCreated(payment: payment)),
    );
  }

  /// Mendapatkan detail pembayaran untuk order tertentu.
  Future<void> getPaymentDetail({required String orderId}) async {
    emit(const PaymentLoading());

    final result = await getPaymentDetailUseCase(
      GetPaymentDetailParams(orderId: orderId),
    );

    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (payment) => emit(PaymentLoaded(payment: payment)),
    );
  }

  /// Mengecek status pembayaran di Payment Gateway.
  Future<void> checkPaymentStatus({required String orderId}) async {
    emit(const PaymentLoading());

    final result = await checkPaymentStatusUseCase(
      CheckPaymentStatusParams(orderId: orderId),
    );

    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (_) => emit(const PaymentStatusChecked()),
    );
  }
}
