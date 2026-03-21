import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class UpdateSellerProfileUsecase
    implements UseCase<bool, UpdateSellerProfileParams> {
  final ChatRepository chatRepository;

  UpdateSellerProfileUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, bool>> call(UpdateSellerProfileParams params) =>
      chatRepository.updateFmcgSellerProfile(params);
}

class UpdateSellerProfileParams {
  final String token;
  final String loginID;
  final String titleID;
  final String genderID;
  final String profileImage;
  final bool isImage;
  final String password;
  final String mobile;
  final String email;
  final String dob;
  final String name;

  UpdateSellerProfileParams({
    required this.token,
    required this.loginID,
    required this.titleID,
    required this.genderID,
    required this.profileImage,
    required this.password,
    required this.mobile,
    required this.email,
    required this.dob,
    required this.name,
    required this.isImage,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "LoginID": loginID,
        "TitleID": titleID,
        "GenderID": genderID,
        "ProfileImage": profileImage,
        "Password": password,
        "Mobile": mobile,
        "Email": email,
        "DOB": dob,
        "isimage": isImage,
        "Name": name,
        "DeviceID": Constants.deviceID,
      };
}
