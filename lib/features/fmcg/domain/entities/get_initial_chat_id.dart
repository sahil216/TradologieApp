import 'package:equatable/equatable.dart';

class GetInitialChatId extends Equatable {
  final int? chatId;
  final int? sellerId;

  const GetInitialChatId({
    this.chatId,
    this.sellerId,
  });

  @override
  List<Object?> get props => [chatId, sellerId];
}
