import 'package:dartz/dartz.dart';
import 'package:app_common/app_common.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final IAuthSession _session;

  AuthRepositoryImpl(this._dataSource, this._session);

  @override
  Result<String> register(String email, String password, String phone) async {
    try {
      final message = await _dataSource.register(email, password, phone);
      return Right(message);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Result<String> forgotPassword(String email) async {
    try {
      final message = await _dataSource.forgotPassword(email);
      return Right(message);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Result<String> verifyResetOtp(String email, String otp) async {
    try {
      final resetToken = await _dataSource.verifyResetOtp(email, otp);
      return Right(resetToken);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Result<String> resetPassword(String email, String resetToken, String newPassword) async {
    try {
      final message = await _dataSource.resetPassword(email, resetToken, newPassword);
      return Right(message);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Result<String> login(String email, String password) async {
    try {
      final message = await _dataSource.login(email, password);
      return Right(message);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Result<void> verifyOtp(String email, String otp) async {
    try {
      await _dataSource.verifyOtp(email, otp);
      return const Right(null);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _session.isLoggedIn.value;
  }

  @override
  Future<void> logout() async {
    await _session.clearSession();
  }
}
