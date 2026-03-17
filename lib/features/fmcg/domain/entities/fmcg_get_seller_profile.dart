import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_gender.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_title.dart';

class FmcgGetSellerProfile extends Equatable {
  final int? loginId;
  final int? titleId;
  final String? fullName;
  final int? genderId;
  final String? profileImage;
  final String? imageType;
  final String? mobile;
  final String? email;
  final String? password;
  final String? dob;
  final String? fromDate;
  final String? toDate;
  final List<FmcgSellerTitle>? fmcgSellerTitle;
  final List<FmcgSellerGender>? fmcgSellerGender;

  const FmcgGetSellerProfile({
    this.loginId,
    this.titleId,
    this.fullName,
    this.genderId,
    this.profileImage,
    this.imageType,
    this.mobile,
    this.email,
    this.password,
    this.dob,
    this.fromDate,
    this.toDate,
    this.fmcgSellerTitle,
    this.fmcgSellerGender,
  });

  @override
  List<Object?> get props => [
        loginId,
        titleId,
        fullName,
        genderId,
        profileImage,
        imageType,
        mobile,
        email,
        password,
        dob,
        fromDate,
        toDate,
        fmcgSellerTitle,
        fmcgSellerGender,
      ];
}
