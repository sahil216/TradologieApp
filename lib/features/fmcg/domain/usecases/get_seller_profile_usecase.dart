import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_get_seller_profile.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class GetSellerProfileParams {
  final String token;
  final String loginID;
  final String deviceID;

  GetSellerProfileParams(
      {required this.token, required this.loginID, required this.deviceID});

  Map<String, dynamic> toJson() =>
      {"Token": token, "LoginID": loginID, "DeviceID": deviceID};
}

class GetSellerProfileUsecase
    implements UseCase<FmcgGetSellerProfile, GetSellerProfileParams> {
  final ChatRepository chatRepository;

  GetSellerProfileUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, FmcgGetSellerProfile>> call(
          GetSellerProfileParams params) =>
      chatRepository.getFmcgSellerProfile(params);
}
