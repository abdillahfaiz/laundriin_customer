import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// UseCase untuk register customer baru.
class Register implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  const Register(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) {
    return repository.register(
      name: params.name,
      phoneNumber: params.phoneNumber,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String phoneNumber;
  final String password;

  const RegisterParams({
    required this.name,
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phoneNumber, password];
}
