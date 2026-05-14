import 'package:equatable/equatable.dart';

class FmcgQuotationTranItem extends Equatable {
  final int quotationTranId;
  final int quotationId;
  final int productId;
  final String productName;
  final String quantity;
  final double quotedRate;
  final double counterOfferRate;
  final String counterOfferAccepted;
  final int attributeValue1Id;
  final int attributeValue2Id;
  final String attributeValueName1;
  final String attributeValueName2;
  final String quotationStatus;

  const FmcgQuotationTranItem({
    required this.quotationTranId,
    required this.quotationId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.quotedRate,
    required this.counterOfferRate,
    required this.counterOfferAccepted,
    required this.attributeValue1Id,
    required this.attributeValue2Id,
    required this.attributeValueName1,
    required this.attributeValueName2,
    required this.quotationStatus,
  });

  @override
  List<Object?> get props => [
        quotationTranId,
        quotationId,
        productId,
        productName,
        quantity,
        quotedRate,
        counterOfferRate,
        counterOfferAccepted,
        attributeValue1Id,
        attributeValue2Id,
        attributeValueName1,
        attributeValueName2,
        quotationStatus,
      ];
}
