import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
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
  final File? profileImage;
  final bool isImage;
  final String password;
  final String mobile;
  final String email;
  final String dob;
  final String name;
  final String countryCode;
  final String countryId;

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
    required this.countryCode,
    required this.countryId,
  });

  Future<Map<String, dynamic>> toJson() async => {
        "Token": token,
        "LoginID": loginID,
        "TitleID": titleID,
        "GenderID": genderID,
        "Password": password,
        "Mobile": mobile,
        "Email": email,
        "DOB": dob,
        "CountryCode": countryCode,
        "CountryID": countryId,
        "isimage": isImage,
        "Name": name,
        "DeviceID": Constants.deviceID,
        if (profileImage != null)
          "ProfileImage": await MultipartFile.fromFile(
            profileImage!.path,
            filename: profileImage!.path.split('/').last,
          )
        else
          "ProfileImage": "",
      };
}
