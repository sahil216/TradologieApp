import 'package:tradologie_app/features/authentication/data/models/fmcg_user_brand_detail_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_user_detail_model.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_signin_response.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_user_brand_detail.dart';

class FmcgSellerSigninResponseModel extends FmcgSellerSigninResponse {
  const FmcgSellerSigninResponseModel({
    super.fmcgUserDetail,
    super.fmcgUserBrandDetail,
  });

  factory FmcgSellerSigninResponseModel.fromJson(Map<String, dynamic> json) =>
      FmcgSellerSigninResponseModel(
        fmcgUserDetail: json["FMCGUserDetail"] == null
            ? null
            : FmcgUserDetailModel.fromJson(json["FMCGUserDetail"]),
        fmcgUserBrandDetail: json["FMCGUserBrandDetail"] == null
            ? []
            : List<FmcgUserBrandDetail>.from(json["FMCGUserBrandDetail"]!
                .map((x) => FmcgUserBrandDetailModel.fromJson(x))),
      );
}
