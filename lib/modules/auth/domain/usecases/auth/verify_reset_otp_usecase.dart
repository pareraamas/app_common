import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_common/app_common.dart';
import '../../repositories/auth_repository.dart';

class VerifyResetOtpUseCase implements UseCase<String, VerifyResetOtpParams> {
  final AuthRepository _repository;

  VerifyResetOtpUseCase(this._repository);

  @override
  Result<String> call(VerifyResetOtpParams params) async {
    if (params.email.isEmpty || params.otp.isEmpty) {
      return const Left(ValidationFailure('Email dan OTP wajib diisi'));
    }
    return await _repository.verifyResetOtp(params.email, params.otp);
  }
}

class VerifyResetOtpParams extends Equatable {
  final String email;
  final String otp;

  const VerifyResetOtpParams({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}
