import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class LogVideoLinkParams extends Equatable {
  final String token;
  final String linkTypeId;

  const LogVideoLinkParams({
    required this.token,
    required this.linkTypeId,
  });

  Map<String, dynamic> toJson() => {
        'Token': token,
        'LinkTypeID': linkTypeId,
      };

  @override
  List<Object?> get props => [token, linkTypeId];
}

class LogVideoLinkUsecase implements UseCase<bool, LogVideoLinkParams> {
  final AuthenticationRepository authenticationRepository;

  LogVideoLinkUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, bool>> call(LogVideoLinkParams params) =>
      authenticationRepository.logVideoLink(params);
}
