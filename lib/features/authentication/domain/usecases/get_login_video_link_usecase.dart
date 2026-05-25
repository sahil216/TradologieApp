import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/login_video_link.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class GetLoginVideoLinkParams extends Equatable {
  final String token;
  final String linkType;

  const GetLoginVideoLinkParams({
    required this.token,
    required this.linkType,
  });

  Map<String, dynamic> toJson() => {
        'Token': token,
        'LinkType': linkType,
      };

  @override
  List<Object?> get props => [token, linkType];
}

class GetLoginVideoLinkUsecase
    implements UseCase<LoginVideoLink, GetLoginVideoLinkParams> {
  final AuthenticationRepository authenticationRepository;

  GetLoginVideoLinkUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, LoginVideoLink>> call(
    GetLoginVideoLinkParams params,
  ) =>
      authenticationRepository.getLoginVideoLink(params);
}
