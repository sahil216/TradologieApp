import 'package:tradologie_app/features/fmcg/domain/entities/get_initial_chat_id.dart';

class GetInitialChatIdModel extends GetInitialChatId {
  const GetInitialChatIdModel({
    super.chatId,
    super.sellerId,
  });

  factory GetInitialChatIdModel.fromJson(Map<String, dynamic> json) =>
      GetInitialChatIdModel(
        chatId: json["ChatID"],
        sellerId: json["SellerID"],
      );
}
