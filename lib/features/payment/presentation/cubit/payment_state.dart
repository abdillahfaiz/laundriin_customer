import 'package:equatable/equatable.dart';

import '../../domain/entities/payment.dart';

/// State untuk Payment Cubit.
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class PaymentCreated extends PaymentState {
  final Payment payment;

  const PaymentCreated({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class PaymentStatusChecked extends PaymentState {
  const PaymentStatusChecked();
}

class PaymentLoaded extends PaymentState {
  final Payment payment;

  const PaymentLoaded({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}
