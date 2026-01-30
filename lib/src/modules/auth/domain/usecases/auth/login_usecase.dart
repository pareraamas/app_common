import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_common/app_common.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<String, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Result<String> call(LoginParams params) async {
    if (params.email.isEmpty || params.password.isEmpty) {
      return const Left(ValidationFailure('Email dan Password wajib diisi'));
    }
    return await _repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
