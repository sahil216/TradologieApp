import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradologie_app/core/api/api_consumer.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/features/app/domain/usecases/check_force_update_usecase.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/response_wrapper/response_wrapper.dart';
import '../../../../core/utils/app_strings.dart';

abstract class AppLocalDataSource {
  Future<bool> changeLang({required String langCode});
  Future<ResponseWrapper<dynamic>?> checkForceUpdate(ForceUpdateParams params);
  Future<ResponseWrapper<dynamic>?> getCustomerDetailsById(NoParams params);
}

class AppLocalDataSourceImpl implements AppLocalDataSource {
  final SharedPreferences sharedPreferences;
  ApiConsumer apiConsumer;

  AppLocalDataSourceImpl(
      {required this.sharedPreferences, required this.apiConsumer});
  @override
  Future<bool> changeLang({required String langCode}) async =>
      await sharedPreferences.setString(AppStrings.locale, langCode);

  @override
  Future<ResponseWrapper<dynamic>?> checkForceUpdate(
      ForceUpdateParams params) async {
    return await apiConsumer.post(
      EndPoints.checkForceUpdate,
      body: await params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getCustomerDetailsById(
      NoParams params) async {
    SecureStorageService storage = SecureStorageService();
    var dparams = await DefaultParams.fromStorage(storage);
    return await apiConsumer.post(
      EndPoints.getCustomerDetailsById,
      body: dparams.toJson(),
    );
  }
}
