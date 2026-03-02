import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';

class AuthorizedPersonTab extends StatefulWidget {
  const AuthorizedPersonTab({super.key});

  @override
  State<AuthorizedPersonTab> createState() => _AuthorizedPersonTabState();
}

class _AuthorizedPersonTabState extends State<AuthorizedPersonTab>
    with SingleTickerProviderStateMixin {
  bool isEnabled = true;
  bool? data = false;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  void getAuthorizedPerson() {}
  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;

  @override
  void initState() {
    super.initState();
    getAuthorizedPerson();
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
    return MultiBlocListener(
      listeners: [
        BlocListener<MyAccountCubit, MyAccountState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is AuthorizedPersonSuccess) {
              data = state.data;
            }
            if (state is AuthorizedPersonError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is AuthorizedPersonSuccess ||
                  current is AuthorizedPersonError ||
                  current is AuthorizedPersonIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is AuthorizedPersonError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getAuthorizedPerson();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getAuthorizedPerson();
                  },
                  errorText: state.failure.msg,
                );
              }
            }
            return const CommonLoader();
          }
          return FadeTransition(
            opacity: _screenFade,
            child: SlideTransition(
              position: _screenSlide,
              child: ScaleTransition(
                scale: _screenScale,
                child: CustomScrollView(
                  slivers: [
                    /// FORM SECTION
                    SliverSafeArea(
                      sliver: SliverPadding(
                        padding: const EdgeInsets.all(12),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label("Authorize Person Name"),
                              _textField(),
                              const SizedBox(height: 16),
                              _label("Designation"),
                              _textField(),
                              const SizedBox(height: 16),
                              _label("Mobile No."),
                              _textField(keyboard: TextInputType.phone),
                              const SizedBox(height: 16),
                              _label("Email ID"),
                              _textField(keyboard: TextInputType.emailAddress),
                              const SizedBox(height: 24),
                              _label("Upload Authorization Document"),
                              const SizedBox(height: 8),
                              _uploadBox(),
                              const SizedBox(height: 24),
                              _label("Enabled"),
                              const SizedBox(height: 8),
                              _yesNoToggle(),
                              const SizedBox(height: 24),
                              _submitButton(),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// Divider
                    SliverToBoxAdapter(
                      child: Container(
                        height: 10,
                        color: Colors.grey.shade200,
                      ),
                    ),

                    /// LIST SECTION
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _authorizedPersonCard(),
                          childCount: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  /// Reusable TextField
  Widget _textField({TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: TextField(
        keyboardType: keyboard,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Upload Box
  Widget _uploadBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_upload_outlined, size: 40),
          const SizedBox(height: 10),
          const Text("Click to upload or drag and drop"),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Browse"),
          )
        ],
      ),
    );
  }

  /// Yes / No Toggle
  Widget _yesNoToggle() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isEnabled = true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isEnabled ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                "Yes",
                style: TextStyle(
                  color: isEnabled ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isEnabled = false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: !isEnabled ? Colors.grey : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                "No",
                style: TextStyle(
                  color: !isEnabled ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Submit Button
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
        child: const Text(
          "Submit",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  /// Authorized Person List Card (Mobile Table Replacement)
  Widget _authorizedPersonCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("S.No: 1", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 10),
                    Icon(Icons.check_circle, size: 18, color: Colors.green),
                  ],
                )
              ],
            ),

            const SizedBox(height: 12),

            const Text("Name: Tradologie"),
            const Text("Designation: CEO"),
            const Text("Mobile: 91999999"),
            const Text("Email: trdl6trd@gmail.com"),
          ],
        ),
      ),
    );
  }
}
