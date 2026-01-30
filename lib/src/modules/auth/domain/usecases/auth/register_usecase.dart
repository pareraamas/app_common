import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_common/app_common.dart';
import '../../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<String, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Result<String> call(RegisterParams params) async {
    if (params.email.isEmpty || params.password.isEmpty) {
      return const Left(ValidationFailure('Email dan Password wajib diisi'));
    }
    return await _repository.register(params.email, params.password, params.phone);
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String phone;

  const RegisterParams({
    required this.email, 
    required this.password,
    this.phone = '',
  });

  @override
  List<Object?> get props => [email, password, phone];
}
