import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';

class RegisterUsecase implements UseCase<bool, RegisterParams> {
  final AuthenticationRepository authenticationRepository;

  RegisterUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, bool>> call(RegisterParams params) =>
      authenticationRepository.register(params);
}

class RegisterParams extends Equatable {
  final String email;
  final String phone;
  final String token;
  final String username;
  final String password;

  const RegisterParams({
    required this.email,
    required this.phone,
    required this.username,
    required this.token,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        phone,
        username,
        token,
        password,
      ];

  Future<Map<String, dynamic>> toJson() async => {
        "Token": token,
        "UserName": username,
        "Password": password,
        "EmailID": email,
        "MobileNo": phone,
      };
}
