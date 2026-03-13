import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/features/chat/presentation/widgets/step_widget.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef3f7),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "INR 1,03,840 (For 3 Months)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Dedicated Brand Storefront"),
                    const Text("Showcase Brand to 1M+ Buyers"),
                    const Text("AI Enabled Engagement Assistant"),
                    const Text("High Volume Traffic Commitment"),
                    const Text("Multi Channel Communication"),
                    const Text("Performance Tracking Dashboard"),
                    const Text("Promotion & Trade Campaigns"),
                    const SizedBox(height: 20),
                    NextButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
