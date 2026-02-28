import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/features/my_account/presentation/screens/buyer_my_account_screen.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();

  static Widget _textField(String hint, {String? initialValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF2F3F5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  static Widget _twoColumnRow(Widget first, Widget second) {
    return Row(
      children: [
        Expanded(child: first),
        const SizedBox(width: 12),
        Expanded(child: second),
      ],
    );
  }

  static Widget _submitButton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7CF6), Color(0xFF1C5ED6)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Center(
        child: Text(
          "Submit",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _AddAddressScreenState extends State<AddAddressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;
  @override
  void initState() {
    super.initState();

    _screenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _screenFade = CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    );

    _screenScale = Tween<double>(
      begin: 0.97,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    _screenSlide = Tween<Offset>(
      begin: const Offset(0, .04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _screenController.forward();
    });
  }

  @override
  void dispose() {
    _screenController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
        body: FadeTransition(
            opacity: _screenFade,
            child: SlideTransition(
                position: _screenSlide,
                child: ScaleTransition(
                  scale: _screenScale,
                  child: CustomScrollView(
                    slivers: [
                      /// ---------------- APP BAR ----------------
                      CommonAppbar(
                        title: "Add Address",
                        showBackButton: true,
                      ),

                      /// ---------------- ADDRESS SECTION ----------------
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: LuxurySectionTitle(title: "Address"),
                        ),
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: GlassCard(
                            child: Column(
                              children: [
                                AddAddressScreen._textField("Address Type"),
                                AddAddressScreen._textField("Name"),
                                AddAddressScreen._textField("Address Line"),
                                AddAddressScreen._twoColumnRow(
                                  AddAddressScreen._textField("Country",
                                      initialValue: "India"),
                                  AddAddressScreen._textField("State/Province",
                                      initialValue: "Uttar Pradesh"),
                                ),
                                AddAddressScreen._twoColumnRow(
                                  AddAddressScreen._textField("City"),
                                  AddAddressScreen._textField("Area"),
                                ),
                                AddAddressScreen._textField("Zip/Postal Code"),
                                AddAddressScreen._textField(
                                    "Port Of Discharge"),
                                AddAddressScreen._textField("Mobile No."),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// ---------------- RECEIVER SECTION ----------------
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        sliver: SliverToBoxAdapter(
                          child: LuxurySectionTitle(
                            title: "Receiver Details",
                          ),
                        ),
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: GlassCard(
                            child: Column(
                              children: [
                                AddAddressScreen._textField("Receiver Name"),
                                AddAddressScreen._textField("Receiver Mobile"),
                                AddAddressScreen._twoColumnRow(
                                  AddAddressScreen._textField(
                                      "Receiver ID Type"),
                                  AddAddressScreen._textField(
                                      "Receiver ID No."),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// ---------------- SUBMIT BUTTON ----------------
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 30, 16, 40),
                        sliver: SliverToBoxAdapter(
                          child: AddAddressScreen._submitButton(),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
