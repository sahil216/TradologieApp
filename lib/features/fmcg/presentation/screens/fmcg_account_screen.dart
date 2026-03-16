import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/stepper_screens/account_info_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/stepper_screens/address_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/stepper_screens/documents_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/stepper_screens/membership_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/stepper_screens/security_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int step = 0;

  final pages = [
    const AccountInfoScreen(),
    const SecurityScreen(),
    const AddressScreen(),
    const DocumentsScreen(),
    const MembershipScreen(),
  ];

  void next() {
    if (step < pages.length - 1) {
      setState(() => step++);
    }
  }

  void back() {
    if (step > 0) {
      setState(() => step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef3f7),
      body: CustomScrollView(
        slivers: [
          /// APPBAR
          CommonAppbar(title: "FMCG My Accounts"),

          /// STICKY STEP HEADER
          SliverPersistentHeader(
            pinned: true,
            delegate: StepHeaderDelegate(step),
          ),

          /// CONTENT
          SliverFillRemaining(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                final slide = Tween(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation);

                return SlideTransition(
                  position: slide,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Container(
                key: ValueKey(step),
                padding: const EdgeInsets.all(16),
                child: pages[step],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StepHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int step;

  StepHeaderDelegate(this.step);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Step ${step + 1} of 5",
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("Registration"),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: (step + 1) / 5,
            minHeight: 6,
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Account",
                style: TextStyleConstants.regular(context, fontSize: 12),
              ),
              Text(
                "Security",
                style: TextStyleConstants.regular(context, fontSize: 12),
              ),
              Text(
                "Address",
                style: TextStyleConstants.regular(context, fontSize: 12),
              ),
              Text(
                "Docs",
                style: TextStyleConstants.regular(context, fontSize: 12),
              ),
              Text(
                "Member",
                style: TextStyleConstants.regular(context, fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 110;

  @override
  double get minExtent => 110;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
