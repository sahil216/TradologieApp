import 'package:tradologie_app/features/fmcg/data/models/fmcg_seller_gender_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/fmcg_seller_title_model.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_get_seller_profile.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_gender.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_title.dart';

class FmcgGetSellerProfileModel extends FmcgGetSellerProfile {
  const FmcgGetSellerProfileModel({
    super.loginId,
    super.titleId,
    super.fullName,
    super.genderId,
    super.profileImage,
    super.imageType,
    super.mobile,
    super.email,
    super.password,
    super.dob,
    super.fromDate,
    super.toDate,
    super.fmcgSellerTitle,
    super.fmcgSellerGender,
    super.analyticsUrl,
    super.brandName,
  });

  factory FmcgGetSellerProfileModel.fromJson(Map<String, dynamic> json) =>
      FmcgGetSellerProfileModel(
        loginId: json["LoginID"],
        titleId: json["TitleID"],
        fullName: json["FullName"],
        genderId: json["GenderID"],
        profileImage: json["ProfileImage"],
        imageType: json["ImageType"],
        mobile: json["Mobile"],
        email: json["Email"],
        password: json["Password"],
        dob: json["DOB"],
        fromDate: json["FromDate"],
        toDate: json["ToDate"],
        brandName: json["BrandName"],
        analyticsUrl: json["Analytics_URL"],
        fmcgSellerTitle: json["FMCGSellerTitle"] == null
            ? []
            : List<FmcgSellerTitle>.from(json["FMCGSellerTitle"]!
                .map((x) => FmcgSellerTitleModel.fromJson(x))),
        fmcgSellerGender: json["FMCGSellerGender"] == null
            ? []
            : List<FmcgSellerGender>.from(json["FMCGSellerGender"]!
                .map((x) => FmcgSellerGenderModel.fromJson(x))),
      );
}
