import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';

class MembershipTab extends StatefulWidget {
  const MembershipTab({super.key});

  @override
  State<MembershipTab> createState() => _MembershipTabState();
}

class _MembershipTabState extends State<MembershipTab> {
  bool? data = false;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  void getMembership() {}

  @override
  void initState() {
    super.initState();
    getMembership();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MyAccountCubit, MyAccountState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is MembershipSuccess) {
              data = state.data;
            }
            if (state is MembershipError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is MembershipSuccess ||
                  current is MembershipError ||
                  current is MembershipIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is MembershipError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getMembership();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getMembership();
                  },
                  errorText: state.failure.msg,
                );
              }
            }
            return const CommonLoader();
          }
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _introText(),
                const SizedBox(height: 16),
                _membershipPlanCard(),
                const SizedBox(height: 16),
                _inauguralOfferCard(),
                const SizedBox(height: 16),
                _videoCard(),
                const SizedBox(height: 16),
                _bankDetailsCard(),
                const SizedBox(height: 24),
                _paymentSection(),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _introText() {
    return Text(
      "Tired of chasing buyers with no results? Spending huge amounts on leads "
      "and trade shows, only to get no return?\n\n"
      "Our Verified Seller Package connects you to 1M+ buyers across 100+ "
      "countries from day one. Unlock your membership today and expand your "
      "global business with confidence.",
      style: const TextStyle(fontSize: 14),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _membershipPlanCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Yearly Subscription (1 Year)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _infoRow("Membership Fee", "₹155,760"),
            _infoRow("Participation Fee", "₹0"),
            _infoRow("Free Participation", "Unlimited"),
            _infoRow("Email Marketing", "4 Mailers"),
            _infoRow("Commission", "1%"),
            _infoRow("E-Brochure", "Eligible"),
            _infoRow("Microsite", "Eligible"),
            _infoRow("Advertisement", "Eligible"),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _inauguralOfferCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Inaugural Offer",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            _Bullet(text: "Membership cost includes GST @ 18%"),
            _Bullet(
                text: "Convenience fee, if applicable, will be charged extra"),
            _Bullet(
                text: "Rates are subject to change without prior intimation"),
            _Bullet(
                text:
                    "Rate changes will not affect current membership duration"),
            _Bullet(
                text:
                    "Renewal shall be done as per applicable rates at that time"),
            _Bullet(
                text: "Participation fee will be adjusted against commission"),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _videoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black12,
                child: const Center(
                  child:
                      Icon(Icons.play_circle_fill, size: 64, color: Colors.red),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "Tradologie Subscription – Quick Features & Benefits",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _bankDetailsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bank Details (For Accounting Purpose)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _infoRow("Account Name", "Super E Factory Depot Private Limited"),
            _infoRow("Account No.", "001484600003135"),
            _infoRow("Bank", "YES Bank"),
            _infoRow("Branch", "Sector-19, Noida"),
            _infoRow("RTGS / IFSC", "YESB0000014"),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _paymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Membership",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          // value: "Yearly Subscription (1 Year)",
          decoration: const InputDecoration(
            labelText: "Membership Plan",
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: "Yearly Subscription (1 Year)",
              child: Text("Yearly Subscription (1 Year)"),
            ),
          ],
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: "155760.00",
          readOnly: true,
          decoration: const InputDecoration(
            labelText: "Membership Amount (INR)",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Proceed To Payment"),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Bullet widget
class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
