import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/network/network_info.dart';
import 'package:zawjati_mobile/core/storage/app_local_storage.dart';
import 'package:zawjati_mobile/core/constants/storage_keys.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final LocalStorage localStorage;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure('No internet connection'));
    }
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await _storeTokens(response);
      return Right(_mapUser(response));
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure('No internet connection'));
    }
    try {
      final response = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      await _storeTokens(response);
      return Right(_mapUser(response));
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.logout();
      }
      await _clearTokens();
      return const Right(null);
    } on Failure catch (f) {
      await _clearTokens();
      return Left(f);
    } catch (e) {
      await _clearTokens();
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> checkAuth() async {
    final accessToken = localStorage.getString(StorageKeys.accessToken);
    if (accessToken == null) {
      return Left(const UnauthorizedFailure('No token found'));
    }
    try {
      final response = await remoteDataSource.getCurrentUser();
      return Right(_mapUser(response));
    } on UnauthorizedFailure {
      await _clearTokens();
      return Left(const UnauthorizedFailure('Session expired'));
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure('No internet connection'));
    }
    try {
      final response = await remoteDataSource.getCurrentUser();
      return Right(_mapUser(response));
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.deleteAccount();
      await _clearTokens();
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<void> _storeTokens(Map<String, dynamic> response) async {
    final accessToken = response['access_token'] as String?;
    final refreshToken = response['refresh_token'] as String?;

    if (accessToken != null) {
      await localStorage.setString(StorageKeys.accessToken, accessToken);
    }
    if (refreshToken != null) {
      await localStorage.setSecureString(
        StorageKeys.refreshToken,
        refreshToken,
      );
    }

    final user = response['user'] as Map<String, dynamic>?;
    if (user != null) {
      final id = user['id'] as String?;
      final email = user['email'] as String?;
      final name = user['name'] as String?;
      if (id != null) {
        await localStorage.setString(StorageKeys.userId, id);
      }
      if (email != null) {
        await localStorage.setString(StorageKeys.userEmail, email);
      }
      if (name != null) {
        await localStorage.setString(StorageKeys.userName, name);
      }
    }
  }

  Future<void> _clearTokens() async {
    await localStorage.remove(StorageKeys.accessToken);
    await localStorage.removeSecure(StorageKeys.refreshToken);
    await localStorage.remove(StorageKeys.userId);
    await localStorage.remove(StorageKeys.userEmail);
    await localStorage.remove(StorageKeys.userName);
  }

  User _mapUser(Map<String, dynamic> response) {
    final userData = response['user'] as Map<String, dynamic>? ?? response;
    return User.fromJson(userData);
  }
}
