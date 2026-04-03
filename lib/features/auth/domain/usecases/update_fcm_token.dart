import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class UpdateFcmToken implements UseCase<void, String> {
  final AuthRepository repository;

  UpdateFcmToken(this.repository);

  @override
  Future<Either<Failure, void>> call(String token) async {
    return await repository.updateFcmToken(token);
  }
}
