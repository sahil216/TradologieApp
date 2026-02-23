import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/respositories/dashboard_repository.dart';

class AddVendorStockEnquiryUsecase
    implements UseCase<bool, AddVendorStockEnquiryParams> {
  final DashboardRepository dasboardRepository;

  AddVendorStockEnquiryUsecase({required this.dasboardRepository});
  @override
  Future<Either<Failure, bool>> call(AddVendorStockEnquiryParams params) =>
      dasboardRepository.addVendorStockEnquiry(params);
}

class AddVendorStockEnquiryParams extends Equatable {
  final String token;
  final String requirementID;
  final String buyerID;
  final String name;
  final String email;
  final String quantity;
  final String countryID;
  final String mobileNo;
  final String unit;
  final String remarks;
  final String insertedID;

  const AddVendorStockEnquiryParams({
    required this.token,
    required this.requirementID,
    required this.buyerID,
    required this.name,
    required this.email,
    required this.quantity,
    required this.countryID,
    required this.mobileNo,
    required this.unit,
    required this.remarks,
    required this.insertedID,
  });

  @override
  List<Object?> get props => [
        token,
        requirementID,
        buyerID,
        name,
        email,
        quantity,
        countryID,
        mobileNo,
        unit,
        remarks,
        insertedID,
      ];

  Map<String, dynamic> toJson() => {
        "Token": token,
        "RequirementID": requirementID,
        "BuyerID": buyerID,
        "Name": name,
        "Email": email,
        "Quantity": quantity,
        "CountryID": countryID,
        "MobileNo": mobileNo,
        "Unit": unit,
        "Remarks": remarks,
        "InsertedID": insertedID,
      };
}
