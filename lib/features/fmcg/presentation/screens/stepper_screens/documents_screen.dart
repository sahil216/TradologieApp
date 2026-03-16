import 'package:flutter/material.dart';
import 'package:tradologie_app/features/fmcg/presentation/widgets/step_widget.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  Widget uploadBox(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {},
            child: const Text("Browse"),
          ),
          const SizedBox(height: 6),
          const Text(
            "Click to upload or drag and drop",
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef3f7),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                uploadBox("Business Registration Certificate"),
                uploadBox("Import / Export License"),
                uploadBox("Tax Registration (GST/VAT)"),
                uploadBox("Company Profile"),
                const SizedBox(height: 20),
                NextButton(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
