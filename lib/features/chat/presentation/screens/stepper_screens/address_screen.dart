import 'package:flutter/material.dart';
import 'package:tradologie_app/features/chat/presentation/widgets/step_widget.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

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
                  label: "Address Type",
                  hint: "Select address type",
                ),
                const FormFieldWidget(
                  label: "Name",
                  hint: "Enter business name",
                ),
                const FormFieldWidget(
                  label: "Address Line",
                  hint: "Enter building & street",
                ),
                const FormFieldWidget(
                  label: "Country",
                  hint: "Select country",
                ),
                const FormFieldWidget(
                  label: "State",
                  hint: "Select state",
                ),
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
