import 'package:flutter/material.dart';
import 'package:tradologie_app/features/chat/presentation/widgets/step_widget.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef3f7),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            title: Text("Security"),
          ),
          const SliverToBoxAdapter(
            child: StepHeader(
              step: "Step 2 of 6",
              next: "Add Address",
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const FormFieldWidget(
                  label: "Create Password",
                  hint: "Enter password",
                ),
                const FormFieldWidget(
                  label: "Confirm Password",
                  hint: "Re-enter password",
                ),
                const SizedBox(height: 20),
                const Text("Password Requirements"),
                const SizedBox(height: 10),
                const Text("✓ At least 8 characters"),
                const Text("✓ One uppercase letter"),
                const Text("○ One number"),
                const Text("○ One special character"),
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
