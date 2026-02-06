import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';

Future<String?> showInputDialog(BuildContext context) async {
  TextEditingController controller = TextEditingController();

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Are you sure you want to delete your Tradologie profile?",
          style: TextStyleConstants.semiBold(context, fontSize: 16),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Reason for deletion",
            hintStyle: TextStyleConstants.medium(context, fontSize: 16),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cancel → returns null
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isEmpty) {
                return;
              }
              Navigator.pop(context, controller.text); // Return input
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}
