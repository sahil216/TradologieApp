import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_gender.dart';

class FmcgSellerGenderModel extends FmcgSellerGender {
  const FmcgSellerGenderModel({
    super.genderId,
    super.genderName,
  });

  factory FmcgSellerGenderModel.fromJson(Map<String, dynamic> json) =>
      FmcgSellerGenderModel(
        genderId: json["GenderID"],
        genderName: json["GenderName"],
      );
}
