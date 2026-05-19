import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/core/widgets/custom_text_field.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/admin_login_usecase.dart';
import 'package:tradologie_app/features/authentication/presentation/cubit/authentication_cubit.dart';

class AdminSignin extends StatefulWidget {
  const AdminSignin({super.key});

  @override
  State<AdminSignin> createState() => _AdminSigninState();
}

class _AdminSigninState extends State<AdminSignin> {
  static const _apiToken = '2018APR031848';

  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _showPassword = ValueNotifier(false);
  final _deviceInfoPlugin = DeviceInfoPlugin();
  final _secureStorage = SecureStorageService();

  String _model = '';
  String _osVersionRelease = '';
  String _deviceId = '';
  String _manufacturer = '';
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _appVersion = info.version);
  }

  Future<void> _initPlatformState() async {
    try {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final build = await _deviceInfoPlugin.androidInfo;
          _manufacturer = build.manufacturer;
          _model = build.model;
          _osVersionRelease = build.version.release;
          _deviceId = build.id;
          break;
        case TargetPlatform.iOS:
          final data = await _deviceInfoPlugin.iosInfo;
          _manufacturer = 'Apple';
          _model = data.modelName;
          _osVersionRelease = data.systemVersion;
          _deviceId = data.identifierForVendor ?? '';
          break;
        default:
          throw UnimplementedError('Platform not supported');
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to get device info: $e');
    }

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();

    final fcmToken = await _secureStorage.read(AppStrings.fcmToken) ?? '';
    if (!mounted) return;

    context.read<AuthenticationCubit>().adminLogin(
          AdminLoginParams(
            userId: _userIdController.text.trim(),
            password: _passwordController.text,
            token: _apiToken,
            manufacturer: _manufacturer,
            model: _model,
            osVersionRelease: _osVersionRelease,
            appVersion: _appVersion,
            fcmToken: fcmToken,
            osType: Platform.isAndroid ? 'Android' : 'iOS',
            deviceId: _deviceId,
          ),
        );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    _showPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AdaptiveScaffold(
        body: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is AdminSignInSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.mainRoute,
                (route) => false,
              );
            }
            if (state is AdminLoginError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
          child: Stack(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: _showPassword,
                builder: (context, showPassword, _) {
                  return CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      const CommonAppbar(
                        title: 'Admin Sign In',
                        showBackButton: true,
                        showNotification: false,
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 20),
                                CommonTextField(
                                  titleText: 'User ID',
                                  hintText: 'Enter User ID',
                                  controller: _userIdController,
                                  textInputType: TextInputType.text,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'User ID is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                CommonTextField(
                                  titleText: CommonStrings.password,
                                  hintText: CommonStrings.enterPassword,
                                  controller: _passwordController,
                                  isObsecureText: !showPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      showPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: AppColors.grayText,
                                    ),
                                    onPressed: () {
                                      _showPassword.value = !_showPassword.value;
                                    },
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                CommonButton(
                                  onPressed: _onLoginPressed,
                                  text: CommonStrings.login,
                                  textStyle: TextStyleConstants.medium(
                                    context,
                                    fontSize: 16,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  if (state is AdminLoginIsLoading) {
                    return const Positioned.fill(child: CommonLoader());
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
