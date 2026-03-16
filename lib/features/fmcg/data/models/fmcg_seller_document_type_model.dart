import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_type.dart';

class FmcgSellerDocumentTypeModel extends FmcgSellerDocumentType {
  const FmcgSellerDocumentTypeModel({
    super.documentTypeId,
    super.documentName,
    super.documentType,
  });

  factory FmcgSellerDocumentTypeModel.fromJson(Map<String, dynamic> json) =>
      FmcgSellerDocumentTypeModel(
        documentTypeId: json["DocumentTypeID"],
        documentName: json["DocumentName"],
        documentType: json["DocumentType"],
      );
}
