import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_common/app_common.dart';
import '../../repositories/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<String, ResetPasswordParams> {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  @override
  Result<String> call(ResetPasswordParams params) async {
    if (params.email.isEmpty || params.resetToken.isEmpty || params.newPassword.isEmpty) {
      return const Left(ValidationFailure('Email, Token, dan Password Baru wajib diisi'));
    }
    return await _repository.resetPassword(params.email, params.resetToken, params.newPassword);
  }
}

class ResetPasswordParams extends Equatable {
  final String email;
  final String resetToken;
  final String newPassword;

  const ResetPasswordParams({
    required this.email,
    required this.resetToken,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, resetToken, newPassword];
}
