import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tradologie_app/features/socket/domain/message_model.dart';
import 'chat_view_model.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ChatsCubit>().connect("", "1");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatsCubit, List<ChatMessage>>(
                builder: (context, messages) {
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final msg = messages[index];
                      return ListTile(
                        title: Text(msg.message),
                        subtitle: Text(msg.user),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(hintText: "Enter message..."),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      context.read<ChatsCubit>().sendMessage(
                            "1", // fromUserId
                            "2", // toUserId
                            controller.text,
                          );
                      controller.clear();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
