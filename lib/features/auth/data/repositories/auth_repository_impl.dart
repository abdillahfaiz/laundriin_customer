import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementasi AuthRepository.
///
/// Mengikuti prinsip **Liskov Substitution** — bisa menggantikan
/// abstract AuthRepository tanpa mengubah behavior konsumen.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String phoneNumber,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await remoteDataSource.login(
        phoneNumber: phoneNumber,
        password: password,
      );

      // Cache user dan tokens
      await localDataSource.cacheUser(result.user);
      if (result.accessToken.isNotEmpty) {
        await localDataSource.cacheTokens(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
        );
      }

      return Right(result.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await remoteDataSource.register(
        name: name,
        phoneNumber: phoneNumber,
        password: password,
      );

      // Cache user dan tokens (jika ada)
      await localDataSource.cacheUser(result.user);
      if (result.accessToken.isNotEmpty) {
        await localDataSource.cacheTokens(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
        );
      }

      return Right(result.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // 1. Cek apakah token akses tersimpan
      final token = await localDataSource.getAccessToken();
      if (token == null || token.isEmpty) {
        return const Left(
          CacheFailure(
            message: 'Token tidak ditemukan, silakan login kembali.',
          ),
        );
      }

      // 2. Jika token ada, ambil data user dari local cache
      final cachedUser = await localDataSource.getCachedUser();

      // Optionally we could fetch remote profile here and silently update cache,
      // tapi untuk splash screen / pengecekan awal, mengandalkan cache lebih responsif & aman.
      return Right(cachedUser);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateFcmToken(String token) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await remoteDataSource.updateFcmToken(token);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
