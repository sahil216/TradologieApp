import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';

class GetAdminChatHistoryUsecase
    implements UseCase<List<ChatMessage>, GetAdminChatHistoryParams> {
  final AdminRepository adminRepository;

  GetAdminChatHistoryUsecase({required this.adminRepository});

  @override
  Future<Either<Failure, List<ChatMessage>>> call(
    GetAdminChatHistoryParams params,
  ) =>
      adminRepository.getChatHistory(params);
}

class GetAdminChatHistoryParams extends Equatable {
  final String apiCode;
  final String fromUserId;
  final int toUserId;
  final String type1;
  final String type2;

  /// Supplier Connect screen: Vendor = me. Admin vendor chat: Admin = me.
  final bool isVendorSide;

  const GetAdminChatHistoryParams({
    required this.apiCode,
    required this.fromUserId,
    required this.toUserId,
    required this.type1,
    required this.type2,
    this.isVendorSide = false,
  });

  Map<String, dynamic> toQueryParameters() => {
        'ApiCode': apiCode,
        'fromUserId': int.tryParse(fromUserId) ?? fromUserId,
        'toUserId': toUserId,
        'Type1': type1,
        'Type2': type2,
      };

  @override
  List<Object?> get props =>
      [apiCode, fromUserId, toUserId, type1, type2, isVendorSide];
}
