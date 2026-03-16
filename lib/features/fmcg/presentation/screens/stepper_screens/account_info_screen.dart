import 'package:flutter/material.dart';
import 'package:tradologie_app/features/fmcg/presentation/widgets/step_widget.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

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
                const FormFieldWidget(
                  label: "Brand Name",
                  hint: "Enter your brand name",
                ),
                const FormFieldWidget(
                  label: "Name / Firm Name",
                  hint: "Enter contact person",
                ),
                const FormFieldWidget(
                  label: "Country",
                  hint: "Select country",
                ),
                const FormFieldWidget(
                  label: "Mobile No",
                  hint: "Enter mobile number",
                ),
                const FormFieldWidget(
                  label: "Email ID / User ID",
                  hint: "Enter email",
                ),
                const SizedBox(height: 20),
                SubmitButton(),
                const SizedBox(height: 12),
                NextButton(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
