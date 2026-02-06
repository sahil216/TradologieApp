import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/save_information_usecase.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/response_wrapper/response_wrapper.dart';
import '../../../../core/utils/secure_storage_service.dart';
import '../../domain/usecases/save_login_control_usecase.dart';

abstract class MyAccountRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> saveInformation(
      SaveInformationParams params);
  Future<ResponseWrapper<dynamic>?> companyDetails(NoParams params);
  Future<ResponseWrapper<dynamic>?> getInformation(NoParams params);
  Future<ResponseWrapper<dynamic>?> uploadVendorImage();
  Future<ResponseWrapper<dynamic>?> saveLoginControl(
      SaveLoginControlParams params);
  Future<ResponseWrapper<dynamic>?> getCompanyDetails();
  Future<ResponseWrapper<dynamic>?> updateCompanyDetails();
  Future<ResponseWrapper<dynamic>?> getCompanyType();
  Future<ResponseWrapper<dynamic>?> getStateList();
  Future<ResponseWrapper<dynamic>?> getCityList();
  Future<ResponseWrapper<dynamic>?> getAreaList();
  Future<ResponseWrapper<dynamic>?> getZipCode();
  Future<ResponseWrapper<dynamic>?> vendorDocumentDetail();
  Future<ResponseWrapper<dynamic>?> updateVendorDocument();
  Future<ResponseWrapper<dynamic>?> getAuthorizePersonList();
  Future<ResponseWrapper<dynamic>?> saveAuthorizePersonDetail();
  Future<ResponseWrapper<dynamic>?> updateAuthorizeDocument();
  Future<ResponseWrapper<dynamic>?> getAgreementFileDetail();
  Future<ResponseWrapper<dynamic>?> updateAgreementDetail();
  Future<ResponseWrapper<dynamic>?> updateAgreementDocument();
  Future<ResponseWrapper<dynamic>?> getBankDetail();
  Future<ResponseWrapper<dynamic>?> saveBankDetail();
  Future<ResponseWrapper<dynamic>?> updateBankDocument();
  Future<ResponseWrapper<dynamic>?> getSellingLocationState();
  Future<ResponseWrapper<dynamic>?> getSellingLocationCity();
  Future<ResponseWrapper<dynamic>?> getVendorSellingLocationDetail();
  Future<ResponseWrapper<dynamic>?> saveUpdateVendorSellingLocation();
  Future<ResponseWrapper<dynamic>?> deleteVendorSellingLocation();
  Future<ResponseWrapper<dynamic>?> getGroupDropDown();
  Future<ResponseWrapper<dynamic>?> getRetailDetails();
  Future<ResponseWrapper<dynamic>?> saveUpdateBulkRetailDetail();
}

class MyAccountRemoteDataSourceImpl implements MyAccountRemoteDataSource {
  ApiConsumer apiConsumer;

  MyAccountRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ResponseWrapper<dynamic>?> saveInformation(
      SaveInformationParams params) async {
    return await apiConsumer.post(EndPoints.saveInformation,
        body: params.toJson());
  }

  @override
  Future<ResponseWrapper<dynamic>?> companyDetails(NoParams params) async {
    SecureStorageService storage = SecureStorageService();
    var dparams = await DefaultParams.fromStorage(storage);
    return await apiConsumer.post(EndPoints.getCompanyDetails,
        body: dparams.toJson());
  }

  @override
  Future<ResponseWrapper<dynamic>?> getInformation(NoParams params) async {
    SecureStorageService storage = SecureStorageService();
    var dparams = await DefaultParams.fromStorage(storage);

    return await apiConsumer.post(EndPoints.getInformation,
        body: dparams.toJson());
  }

  @override
  Future<ResponseWrapper<dynamic>?> uploadVendorImage() async {
    return await apiConsumer.post(EndPoints.uploadVendorImage);
  }

  @override
  Future<ResponseWrapper<dynamic>?> saveLoginControl(
      SaveLoginControlParams params) async {
    return await apiConsumer.post(EndPoints.saveLoginControl,
        body: params.toJson());
  }

  @override
  Future<ResponseWrapper<dynamic>?> getCompanyDetails() async {
    return await apiConsumer.post(EndPoints.getCompanyDetails);
  }

  @override
  Future<ResponseWrapper<dynamic>?> updateCompanyDetails() async {
    return await apiConsumer.post(EndPoints.updateCompanyDetails);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getCompanyType() async {
    return await apiConsumer.post(EndPoints.getCompanyType);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getStateList() async {
    return await apiConsumer.post(EndPoints.getStateList);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getCityList() async {
    return await apiConsumer.post(EndPoints.getCityList);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getAreaList() async {
    return await apiConsumer.post(EndPoints.getAreaList);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getZipCode() async {
    return await apiConsumer.post(EndPoints.getZipCode);
  }

  @override
  Future<ResponseWrapper<dynamic>?> vendorDocumentDetail() async {
    return await apiConsumer.post(EndPoints.vendorDocumentDetail);
  }

  @override
  Future<ResponseWrapper<dynamic>?> updateVendorDocument() async {
    return await apiConsumer.post(EndPoints.updateVendorDocument);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getAuthorizePersonList() async {
    return await apiConsumer.post(EndPoints.getAuthorizePersonList);
  }

  @override
  Future<ResponseWrapper<dynamic>?> saveAuthorizePersonDetail() async {
    return await apiConsumer.post(EndPoints.saveAuthorizePersonDetail);
  }

  @override
  Future<ResponseWrapper<dynamic>?> updateAuthorizeDocument() async {
    return await apiConsumer.post(EndPoints.updateAuthorizeDocument);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getAgreementFileDetail() async {
    return await apiConsumer.post(EndPoints.getAgreementFileDetail);
  }

  @override
  Future<ResponseWrapper<dynamic>?> updateAgreementDetail() async {
    return await apiConsumer.post(EndPoints.updateAgreementDetail);
  }

  @override
  Future<ResponseWrapper<dynamic>?> updateAgreementDocument() async {
    return await apiConsumer.post(EndPoints.updateAgreementDocument);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getBankDetail() async {
    return await apiConsumer.post(EndPoints.getBankDetail);
  }

  @override
  Future<ResponseWrapper<dynamic>?> saveBankDetail() async {
    return await apiConsumer.post(EndPoints.saveBankDetail);
  }

  @override
  Future<ResponseWrapper<dynamic>?> updateBankDocument() async {
    return await apiConsumer.post(EndPoints.updateBankDocument);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getSellingLocationState() async {
    return await apiConsumer.post(EndPoints.getSellingLocationState);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getSellingLocationCity() async {
    return await apiConsumer.post(EndPoints.getSellingLocationCity);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getVendorSellingLocationDetail() async {
    return await apiConsumer.post(EndPoints.getVendorSellingLocationDetail);
  }

  @override
  Future<ResponseWrapper<dynamic>?> saveUpdateVendorSellingLocation() async {
    return await apiConsumer.post(EndPoints.saveUpdateVendorSellingLocation);
  }

  @override
  Future<ResponseWrapper<dynamic>?> deleteVendorSellingLocation() async {
    return await apiConsumer.delete(EndPoints.deleteVendorSellingLocation);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getGroupDropDown() async {
    return await apiConsumer.post(EndPoints.getGroupDropDown);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getRetailDetails() async {
    return await apiConsumer.post(EndPoints.getRetailDetails);
  }

  @override
  Future<ResponseWrapper<dynamic>?> saveUpdateBulkRetailDetail() async {
    return await apiConsumer.post(EndPoints.saveUpdateBulkRetailDetail);
  }
}
