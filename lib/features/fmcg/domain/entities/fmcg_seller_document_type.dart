import 'package:equatable/equatable.dart';

class FmcgSellerDocumentType extends Equatable {
  final int? documentTypeId;
  final String? documentName;
  final String? documentType;

  const FmcgSellerDocumentType({
    this.documentTypeId,
    this.documentName,
    this.documentType,
  });

  @override
  List<Object?> get props => [documentTypeId, documentName, documentType];
}
