import 'package:tradologie_app/features/fmcg/data/models/fmcg_seller_document_list_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/fmcg_seller_document_type_model.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_detail.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_type.dart';

class FmcgSellerDocumentDetailModel extends FmcgSellerDocumentDetail {
  const FmcgSellerDocumentDetailModel({
    super.fmcgSellerDocumentType,
    super.fmcgSellerDocument,
  });

  factory FmcgSellerDocumentDetailModel.fromJson(Map<String, dynamic> json) =>
      FmcgSellerDocumentDetailModel(
        fmcgSellerDocumentType: json["FMCGSellerDocumentType"] == null
            ? []
            : List<FmcgSellerDocumentType>.from(json["FMCGSellerDocumentType"]!
                .map((x) => FmcgSellerDocumentTypeModel.fromJson(x))),
        fmcgSellerDocument: json["FMCGSellerDocument"] == null
            ? []
            : List<FmcgSellerDocumentList>.from(json["FMCGSellerDocument"]!
                .map((x) => FmcgSellerDocumentListModel.fromJson(x))),
      );
}
