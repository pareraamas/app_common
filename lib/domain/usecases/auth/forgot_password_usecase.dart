import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_common/app_common.dart';
import '../../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<String, String> {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Result<String> call(String email) async {
    if (email.isEmpty) {
      return const Left(ValidationFailure('Email wajib diisi'));
    }
    return await _repository.forgotPassword(email);
  }
}
