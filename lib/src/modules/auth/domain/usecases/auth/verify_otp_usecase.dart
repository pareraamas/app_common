import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_common/app_common.dart';
import '../../repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<void, VerifyOtpParams> {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Result<void> call(VerifyOtpParams params) async {
    if (params.email.isEmpty || params.otp.isEmpty) {
      return const Left(ValidationFailure('Email dan OTP wajib diisi'));
    }
    return await _repository.verifyOtp(params.email, params.otp);
  }
}

class VerifyOtpParams extends Equatable {
  final String email;
  final String otp;

  const VerifyOtpParams({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}
