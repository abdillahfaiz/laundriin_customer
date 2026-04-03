import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// UseCase untuk mengecek status autentikasi saat aplikasi dibuka.
///
/// Mengecek apakah user sudah login sebelumnya dengan memeriksa
/// token yang tersimpan di local storage.
class CheckAuthStatus implements UseCase<User, NoParams> {
  final AuthRepository repository;

  const CheckAuthStatus(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}
