import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/extensions.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/core/widgets/custom_text_field.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/forgotpasswordsendotpusecase.dart';
import 'package:tradologie_app/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tradologie_app/features/authentication/presentation/viewmodel/forgot_password_verify_otp_args.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const _apiToken = '2018APR031848';

  final _userIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();

    context.read<AuthenticationCubit>().forgotPasswordSendOtp(
          ForgotPasswordSendOtpParams(
            userId: _userIdController.text.trim(),
            token: _apiToken,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AdaptiveScaffold(
        body: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is ForgotPasswordSendOtpSuccess) {
              final message = state.data.message?.trim();
              if (message?.isNotEmpty == true) {
                CommonToast.success(message!);
              } else {
                CommonToast.success('OTP sent successfully');
              }
              Navigator.pushNamed(
                context,
                Routes.forgotPasswordVerifyOtpRoute,
                arguments: ForgotPasswordVerifyOtpArgs(
                  userId: _userIdController.text.trim(),
                  vendorId: state.data.vendorId,
                ),
              );
            }
            if (state is ForgotPasswordSendOtpError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
          child: Stack(
            children: [
              CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  const CommonAppbar(
                    title: 'Forgot Password',
                    showBackButton: true,
                    showNotification: false,
                    expandedHeight: 64,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Enter your registered email or User ID. We will send you an OTP to reset your password.',
                              style: TextStyleConstants.regular(
                                context,
                                fontSize: 14,
                                color: AppColors.defaultText,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CommonTextField(
                              titleText: 'Email / User ID',
                              hintText: 'Enter email or User ID',
                              controller: _userIdController,
                              textInputType: TextInputType.text,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                final trimmed = value?.trim() ?? '';
                                if (trimmed.isEmpty) {
                                  return 'Email or User ID is required';
                                }
                                if (trimmed.contains('@') &&
                                    !trimmed.isEmailValid) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CommonButton(
                              height: 46,
                              onPressed: _onSubmit,
                              text: 'Send OTP',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                buildWhen: (previous, current) =>
                    current is ForgotPasswordSendOtpIsLoading ||
                    previous is ForgotPasswordSendOtpIsLoading,
                builder: (context, state) {
                  if (state is ForgotPasswordSendOtpIsLoading) {
                    return const CommonLoader();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
