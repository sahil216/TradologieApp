import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_user_brand_detail.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_user_detail.dart';

class FmcgSellerSigninResponse extends Equatable {
  final FmcgUserDetail? fmcgUserDetail;
  final List<FmcgUserBrandDetail>? fmcgUserBrandDetail;

  const FmcgSellerSigninResponse({
    this.fmcgUserDetail,
    this.fmcgUserBrandDetail,
  });

  @override
  List<Object?> get props => [fmcgUserDetail, fmcgUserBrandDetail];
}
