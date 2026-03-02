import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';

class BankDetailsTab extends StatefulWidget {
  const BankDetailsTab({super.key});

  @override
  State<BankDetailsTab> createState() => _BankDetailsTabState();
}

class _BankDetailsTabState extends State<BankDetailsTab>
    with SingleTickerProviderStateMixin {
  bool? data = false;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  void getBankDetails() {}

  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;

  @override
  void initState() {
    super.initState();
    getBankDetails();
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
            if (state is BankDetailsSuccess) {
              data = state.data;
            }
            if (state is BankDetailsError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is BankDetailsSuccess ||
                  current is BankDetailsError ||
                  current is BankDetailsIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is BankDetailsError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getBankDetails();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getBankDetails();
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
                      child: CustomScrollView(slivers: [
                        SliverSafeArea(
                            sliver: SliverPadding(
                                padding: const EdgeInsets.all(12),
                                sliver: SliverPadding(
                                  padding: const EdgeInsets.all(16),
                                  sliver: SliverToBoxAdapter(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildLabel("Account Name"),
                                        _buildTextField(
                                          hint:
                                              "Chamy Engineering And Lubrication Pvt Ltd",
                                        ),
                                        const SizedBox(height: 16),
                                        _buildLabel("Account Number"),
                                        _buildTextField(
                                          hint: "546475685338569",
                                          keyboardType: TextInputType.number,
                                        ),
                                        const SizedBox(height: 16),
                                        _buildLabel("Bank Name"),
                                        _buildTextField(
                                          hint: "BANK OF MAHARASHTRA",
                                        ),
                                        const SizedBox(height: 16),
                                        _buildLabel("Branch"),
                                        _buildTextField(
                                          hint:
                                              "LAW KINS INDUSTRIES GHODBUNDER RD THA",
                                        ),
                                        const SizedBox(height: 16),
                                        _buildLabel("IFSC Code"),
                                        _buildTextField(
                                          hint: "MAHB0001302",
                                        ),
                                        const SizedBox(height: 24),
                                        _buildLabel("Upload Cancel Cheque"),
                                        const SizedBox(height: 8),
                                        _buildUploadBox(),
                                        const SizedBox(height: 32),
                                        _buildSubmitButton(),
                                        const SizedBox(height: 40),
                                      ],
                                    ),
                                  ),
                                )))
                      ]))));
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  /// TextField
  Widget _buildTextField({
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  /// Upload Box
  Widget _buildUploadBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade400,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_upload_outlined, size: 40),
          const SizedBox(height: 12),
          const Text(
            "Click to upload or drag and drop",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            child: const Text("Browse"),
          ),
        ],
      ),
    );
  }

  /// Submit Button
  Widget _buildSubmitButton() {
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
}
