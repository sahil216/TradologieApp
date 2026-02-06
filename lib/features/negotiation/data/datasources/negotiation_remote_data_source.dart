import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/response_wrapper/response_wrapper.dart';
import '../../domain/usecases/get_negotiation_usecase.dart';

abstract class NegotiationRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> getNegotiationData(
      GetNegotiationParams params);
  Future<ResponseWrapper<dynamic>?> buyerNegotiationData(
      GetNegotiationParams params);
}

class NegotiationRemoteDataSourceImpl implements NegotiationRemoteDataSource {
  ApiConsumer apiConsumer;

  NegotiationRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ResponseWrapper<dynamic>?> getNegotiationData(
      GetNegotiationParams params) async {
    return await apiConsumer.post(
      EndPoints.getNegotiation(UserType.supplier),
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> buyerNegotiationData(
      GetNegotiationParams params) async {
    return await apiConsumer.post(
      EndPoints.getNegotiation(UserType.buyer),
      body: params.toJson(),
    );
  }
}
