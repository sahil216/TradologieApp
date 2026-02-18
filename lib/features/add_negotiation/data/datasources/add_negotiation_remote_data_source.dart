import 'package:tradologie_app/core/api/api_consumer.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/response_wrapper/response_wrapper.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_item_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_supplier_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_detail_for_edit_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_item_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/create_auction_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_auction_item_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_list_usecase.dart';

import '../../domian/usecases/add_update_auction_usecase.dart';

abstract class AddNegotiationRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> getCategoryList(NoParams params);
  Future<ResponseWrapper<dynamic>?> addSupplierShortList(
      AddShortListSupplierParams params);
  Future<ResponseWrapper<dynamic>?> deleteSupplierShortList(
      RemoveSupplierShortlistParams params);
  Future<ResponseWrapper<dynamic>?> getSupplierList(SupplierListParams params);
  Future<ResponseWrapper<dynamic>?> getSupplierShortlisted(
      SupplierListParams params);
  Future<ResponseWrapper<dynamic>?> createAuction(CreateAuctionParams params);
  Future<ResponseWrapper<dynamic>?> auctionItemList(
      AuctionItemListParams params);
  Future<ResponseWrapper<dynamic>?> gradleFileUpload(NoParams params);
  Future<ResponseWrapper<dynamic>?> addAuctionItem(AddAuctionItemParams params);
  Future<ResponseWrapper<dynamic>?> packingImageUpload(NoParams params);
  Future<ResponseWrapper<dynamic>?> auctionDetailForEdit(
      AuctionDetailForEditParams params);
  Future<ResponseWrapper<dynamic>?> addAuctionSupplier(
      AddAuctionSupplierParams params);
  Future<ResponseWrapper<dynamic>?> addAuctionSupplierList(NoParams params);
  Future<ResponseWrapper<dynamic>?> deleteAuctionItem(
      DeleteAuctionItemParams params);
  Future<ResponseWrapper<dynamic>?> addUpdateAuction(
      AddUpdateAuctionParams params);
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
    return await apiConsumer.post(
      EndPoints.supplierList,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getSupplierShortlisted(
      SupplierListParams params) async {
    return await apiConsumer.get(
      "${EndPoints.supplierShortListed}/${params.groupID}/${params.customerId}",
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> createAuction(
      CreateAuctionParams params) async {
    return await apiConsumer.post(
      EndPoints.createAuction,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> gradleFileUpload(NoParams params) async {
    return await apiConsumer.post(
      EndPoints.gradleFileUpload,
      body: {},
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> addAuctionItem(
      AddAuctionItemParams params) async {
    return await apiConsumer.post(
      EndPoints.addAuctionItem,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> packingImageUpload(NoParams params) async {
    return await apiConsumer.post(
      EndPoints.packingImageUpload,
      body: {},
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> auctionDetailForEdit(
      AuctionDetailForEditParams params) async {
    return await apiConsumer.post(
      EndPoints.auctionDetailForEdit,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> addAuctionSupplier(
      AddAuctionSupplierParams params) async {
    return await apiConsumer.post(
      EndPoints.addAuctionSupplier,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> auctionItemList(
      AuctionItemListParams params) async {
    return await apiConsumer.post(
      EndPoints.auctionItemList,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> deleteAuctionItem(
      DeleteAuctionItemParams params) async {
    return await apiConsumer.post(
      EndPoints.deleteAuctionItem,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> addAuctionSupplierList(
      NoParams params) async {
    return await apiConsumer.get(
      EndPoints.addAuctionSupplierList,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> addUpdateAuction(
      AddUpdateAuctionParams params) async {
    return await apiConsumer.post(
      EndPoints.addUpdateAuction,
      body: params.toJson(),
    );
  }
}
