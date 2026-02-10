import 'package:tradologie_app/core/api/api_consumer.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/response_wrapper/response_wrapper.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_list_usecase.dart';

abstract class AddNegotiationRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> getCategoryList(NoParams params);
  Future<ResponseWrapper<dynamic>?> addSupplierShortList(
      AddShortListSupplierParams params);
  Future<ResponseWrapper<dynamic>?> deleteSupplierShortList(
      RemoveSupplierShortlistParams params);
  Future<ResponseWrapper<dynamic>?> getSupplierList(SupplierListParams params);
  Future<ResponseWrapper<dynamic>?> getSupplierShortlisted(
      SupplierListParams params);
}

class AddNegotiationRemoteDataSourceImpl
    implements AddNegotiationRemoteDataSource {
  ApiConsumer apiConsumer;

  AddNegotiationRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ResponseWrapper<dynamic>?> getCategoryList(NoParams params) async {
    return await apiConsumer.get(
      EndPoints.getCategoryList,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> addSupplierShortList(
      AddShortListSupplierParams params) async {
    return await apiConsumer.post(
      EndPoints.addSupplierShortList,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> deleteSupplierShortList(
      RemoveSupplierShortlistParams params) async {
    return await apiConsumer.get(
      EndPoints.deleteSupplierShortList,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getSupplierList(
      SupplierListParams params) async {
    return await apiConsumer.get(
      "${EndPoints.supplierList}/${params.groupID}/${params.customerId}",
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getSupplierShortlisted(
      SupplierListParams params) async {
    return await apiConsumer.get(
      "${EndPoints.supplierShortListed}/${params.groupID}/${params.customerId}",
    );
  }
}
