import 'package:equatable/equatable.dart';

class FmcgSellerDocumentList extends Equatable {
  final int? documentId;
  final int? loginId;
  final int? documentTypeId;
  final String? document;
  final String? documentType;
  final String? contentType;
  final String? description;
  final int? priority;
  final int? insertedId;
  final String? insertedDate;
  final int? updatedId;
  final String? updatedDate;

  const FmcgSellerDocumentList({
    this.documentId,
    this.loginId,
    this.documentTypeId,
    this.document,
    this.documentType,
    this.contentType,
    this.description,
    this.priority,
    this.insertedId,
    this.insertedDate,
    this.updatedId,
    this.updatedDate,
  });

  @override
  List<Object?> get props => [
        documentId,
        loginId,
        documentTypeId,
        document,
        documentType,
        contentType,
        description,
        priority,
        insertedId,
        insertedDate,
        updatedId,
        updatedDate,
      ];
}
