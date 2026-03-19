import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_login_success.dart';

class FmcgBuyerLoginSuccessModel extends FmcgBuyerLoginSuccess {
  const FmcgBuyerLoginSuccessModel({
    super.rowNum,
    super.quotationUserId,
    super.userId,
    super.name,
    super.countryCode,
    super.mobile,
    super.email,
    super.password,
    super.insertedId,
    super.insertedDate,
    super.updatedDate,
    super.updatedId,
    super.companyName,
    super.interestedBrandName,
    super.perferredLocation,
    super.brandId,
    super.apiVerificationCode,
  });

  factory FmcgBuyerLoginSuccessModel.fromJson(Map<String, dynamic> json) =>
      FmcgBuyerLoginSuccessModel(
        rowNum: json["RowNum"],
        quotationUserId: json["QuotationUserId"],
        userId: json["UserId"],
        name: json["Name"],
        countryCode: json["CountryCode"],
        mobile: json["Mobile"],
        email: json["Email"],
        password: json["Password"],
        insertedId: json["InsertedId"],
        insertedDate: json["InsertedDate"],
        updatedDate: json["UpdatedDate"],
        updatedId: json["UpdatedId"],
        companyName: json["CompanyName"],
        interestedBrandName: json["InterestedBrandName"],
        perferredLocation: json["PerferredLocation"],
        brandId: json["BrandID"],
        apiVerificationCode: json["ApiVerificationCode"],
      );
}
