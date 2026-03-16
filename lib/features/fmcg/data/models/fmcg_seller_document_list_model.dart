import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_list.dart';

class FmcgSellerDocumentListModel extends FmcgSellerDocumentList {
  const FmcgSellerDocumentListModel({
    super.documentId,
    super.loginId,
    super.documentTypeId,
    super.document,
    super.documentType,
    super.contentType,
    super.description,
    super.priority,
    super.insertedId,
    super.insertedDate,
    super.updatedId,
    super.updatedDate,
  });

  factory FmcgSellerDocumentListModel.fromJson(Map<String, dynamic> json) =>
      FmcgSellerDocumentListModel(
        documentId: json["DocumentID"],
        loginId: json["LoginID"],
        documentTypeId: json["DocumentTypeID"],
        document: json["Document"],
        documentType: json["DocumentType"],
        contentType: json["ContentType"],
        description: json["Description"],
        priority: json["Priority"],
        insertedId: json["InsertedID"],
        insertedDate: json["InsertedDate"],
        updatedId: json["UpdatedID"],
        updatedDate: json["UpdatedDate"],
      );
}
