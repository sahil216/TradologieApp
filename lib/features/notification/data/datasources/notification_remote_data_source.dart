import 'package:tradologie_app/core/utils/constants.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/response_wrapper/response_wrapper.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/secure_storage_service.dart';

abstract class NotificationRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> getNotification(NoParams params);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  ApiConsumer apiConsumer;

  NotificationRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ResponseWrapper<dynamic>?> getNotification(NoParams params) async {
    SecureStorageService storage = SecureStorageService();
    var dparams = await DefaultParams.fromStorage(storage);
    return await apiConsumer.post(
      Constants.isBuyer == true
          ? EndPoints.getNotification(UserType.buyer)
          : EndPoints.getNotification(UserType.supplier),
      body: dparams.toJson(),
    );
  }
}
