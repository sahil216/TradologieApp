import 'package:tradologie_app/core/usecases/usecase.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/response_wrapper/response_wrapper.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/secure_storage_service.dart';
import '../../domain/usecases/get_admin_vendor_list_usecase.dart';

abstract class AdminRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> getVendorList(
    GetAdminVendorListParams params,
  );

  Future<ResponseWrapper<dynamic>?> getAgroSellerChatList(NoParams params);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final ApiConsumer apiConsumer;

  AdminRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ResponseWrapper<dynamic>?> getVendorList(
    GetAdminVendorListParams params,
  ) async {
    final storage = SecureStorageService();
    final token =
        await storage.read(AppStrings.apiVerificationCode) ?? Constants.token;

    return (await apiConsumer.post(
      EndPoints.adminVendorList,
      body: params.toJson(token),
    )) as ResponseWrapper<dynamic>?;
  }

  @override
  Future<ResponseWrapper<dynamic>?> getAgroSellerChatList(
    NoParams params,
  ) async {
    final storage = SecureStorageService();
    final token =
        await storage.read(AppStrings.apiVerificationCode) ?? Constants.token;

    return (await apiConsumer.post(
      EndPoints.adminAgroSellerChatList,
      body: {'Token': token},
    )) as ResponseWrapper<dynamic>?;
  }
}
