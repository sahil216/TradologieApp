import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_type.dart';

class FmcgSellerDocumentDetail extends Equatable {
  final List<FmcgSellerDocumentType>? fmcgSellerDocumentType;
  final List<FmcgSellerDocumentList>? fmcgSellerDocument;

  const FmcgSellerDocumentDetail({
    this.fmcgSellerDocumentType,
    this.fmcgSellerDocument,
  });

  @override
  List<Object?> get props => [fmcgSellerDocumentType, fmcgSellerDocument];
}
