import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Contract abstrak untuk Auth Repository.
///
/// Mengikuti prinsip **Dependency Inversion** — domain layer
/// mendefinisikan interface, data layer mengimplementasikan.
abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String name,
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> updateFcmToken(String token);
}
