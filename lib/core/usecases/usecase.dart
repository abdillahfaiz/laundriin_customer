import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Contract abstrak untuk semua UseCase.
///
/// - [Type] = tipe return value yang diharapkan
/// - [Params] = parameter yang dibutuhkan
///
/// Mengikuti prinsip **Interface Segregation** — setiap UseCase
/// hanya punya satu method `call`.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Digunakan ketika UseCase tidak membutuhkan parameter.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
