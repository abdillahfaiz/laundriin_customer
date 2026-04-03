import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// UseCase untuk login.
///
/// Mengikuti prinsip **Single Responsibility** — hanya bertanggung
/// jawab untuk satu operasi: login.
class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  const Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(
      phoneNumber: params.phoneNumber,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String phoneNumber;
  final String password;

  const LoginParams({required this.phoneNumber, required this.password});

  @override
  List<Object?> get props => [phoneNumber, password];
}
