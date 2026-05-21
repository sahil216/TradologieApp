import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/forgotpasswordsendotpusecase.dart';
import 'package:tradologie_app/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tradologie_app/features/authentication/presentation/viewmodel/forgot_password_verify_otp_args.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  final ForgotPasswordVerifyOtpArgs args;

  const ForgotPasswordVerifyOtpScreen({super.key, required this.args});

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  static const _apiToken = '2018APR031848';

  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late int _secondsLeft;
  Timer? _timer;

  bool get _canResend => _secondsLeft == 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _secondsLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _resendOtp() {
    if (!_canResend) return;
    context.read<AuthenticationCubit>().forgotPasswordSendOtp(
          ForgotPasswordSendOtpParams(
            userId: widget.args.userId,
            token: _apiToken,
          ),
        );
    _startTimer();
  }

  void _onVerify() {
    if (_otpController.text.trim().length != 6) {
      CommonToast.error('Please enter 6-digit OTP');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    // TODO: Wire forgot-password verify OTP API when available.
    CommonToast.success('OTP entered. Reset password step can be added next.');
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
              CommonToast.success(
                message?.isNotEmpty == true
                    ? message!
                    : 'OTP resent successfully',
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
                    title: 'Verify OTP',
                    showBackButton: true,
                    showNotification: false,
                    expandedHeight: 64,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            CommonText(
                              'Enter the OTP sent to your registered contact for',
                              textAlign: TextAlign.center,
                              style: TextStyleConstants.regular(
                                context,
                                fontSize: 14,
                                color: AppColors.defaultText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CommonText(
                              widget.args.userId,
                              textAlign: TextAlign.center,
                              style: TextStyleConstants.semiBold(
                                context,
                                fontSize: 16,
                                color: AppColors.defaultText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: CommonText(
                                'Change email / User ID',
                                textAlign: TextAlign.center,
                                style: TextStyleConstants.regular(
                                  context,
                                  fontSize: 14,
                                  color: AppColors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: Pinput(
                                length: 6,
                                autofocus: true,
                                showCursor: true,
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                separatorBuilder: (_) => const SizedBox(width: 8),
                                onCompleted: (_) => _onVerify(),
                                defaultPinTheme: PinTheme(
                                  height: 56,
                                  width: 48,
                                  textStyle: TextStyleConstants.semiBold(
                                    context,
                                    fontSize: 16,
                                    color: AppColors.black,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.border,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: _canResend ? _resendOtp : null,
                              child: Text(
                                _canResend
                                    ? 'Resend OTP'
                                    : 'Resend OTP in $_secondsLeft s',
                                style: TextStyleConstants.medium(
                                  context,
                                  fontSize: 14,
                                  color: _canResend
                                      ? AppColors.primary
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            CommonButton(
                              height: 46,
                              onPressed: _onVerify,
                              text: CommonStrings.verifyOtp,
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
