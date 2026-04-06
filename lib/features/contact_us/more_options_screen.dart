import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/analytics_services.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_social_icons.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/domain/usecases/check_force_update_usecase.dart';
import 'package:tradologie_app/features/app/presentation/cubit/app_cubit.dart';
import 'package:tradologie_app/features/app/presentation/widgets/input_dialog.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/delete_account_usecase.dart';
import 'package:tradologie_app/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../injection_container.dart';

class MoreOptionsScreen extends StatefulWidget {
  const MoreOptionsScreen({super.key});

  @override
  State<MoreOptionsScreen> createState() => _MoreOptionsScreenState();
}

class _MoreOptionsScreenState extends State<MoreOptionsScreen>
    with SingleTickerProviderStateMixin {
  SecureStorageService secureStorage = SecureStorageService();

  String name = "";
  bool showUpdate = false;

  late AppCubit _appCubit;

  @override
  void initState() {
    super.initState();
    _appCubit = BlocProvider.of<AppCubit>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVersion();
      getName();
    });
  }

  Future<void> _checkVersion() async {
    final version = await getAppVersion();
    _appCubit.checkForceUpdate(
      ForceUpdateParams(
          token: "2018APR031848",
          appVersion: version,
          isAndroid: Platform.isAndroid ? true : false),
    );
  }

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<String> getName() async {
    return name = Constants.isFmcg == true
        ? await secureStorage.read(AppStrings.fmcgName) ?? ""
        : Constants.isBuyer == true
            ? await secureStorage.read(AppStrings.customerName) ?? ""
            : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    _appCubit = context.read<AppCubit>();

    return AdaptiveScaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationCubit, AuthenticationState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state is SignOutSuccess) {
                CommonToast.success("Signed Out Successfully");
                Constants.isLogin = false;
                Constants.isFmcg = false;
                SecureStorageService secureStorage = SecureStorageService();
                secureStorage.delete(AppStrings.apiVerificationCode);
                Constants.token = "";
                secureStorage.write(AppStrings.isFmcg, false.toString());

                secureStorage.write(AppStrings.appSession, false.toString());

                sl<NavigationService>().pushNamedAndRemoveUntil(
                  Routes.onboardingRoute,
                );
              }
              if (state is SignOutError) {
                CommonToast.showFailureToast(state.failure);
              }
              if (state is DeleteAccountSuccess) {
                BlocProvider.of<AuthenticationCubit>(context)
                    .signOut(NoParams());
              }
              if (state is DeleteAccountError) {
                CommonToast.showFailureToast(state.failure);
              }
            },
          ),
          BlocListener<AppCubit, AppState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state is CheckForceUpdateSuccess) {
                setState(() => showUpdate = false);
              }
              if (state is CheckForceUpdateError) {
                setState(() => showUpdate = true);
              }
            },
          ),
        ],

        /// 💎 SLIVER STRUCTURE START
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                /// ⭐ COMMON APPBAR
                Constants.isFmcg
                    ? CommonAppbar(
                        title: "More",
                        showBackButton: false,
                        showNotification: false,
                      )
                    : CommonAppbar(
                        title: "More",
                        showNotification:
                            Constants.isFmcg == true ? false : true,
                      ),

                /// ⭐ BODY
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Column(
                      children: [
                        /// PROFILE HEADER
                        _profileHeader(context),

                        const SizedBox(height: 28),

                        /// GENERAL SECTION
                        _sectionTitle(context, "GENERAL"),

                        _ultraTile(
                          icon: Icons.contact_support_outlined,
                          title: "Contact Us",
                          onTap: () {
                            sl<NavigationService>()
                                .pushNamed(Routes.contactUsScreen);
                          },
                        ),

                        _ultraTile(
                          icon: Icons.share_outlined,
                          title: "Share App",
                          onTap: () {
                            SharePlus.instance.share(
                              ShareParams(
                                text:
                                    '${Constants.name} invited you to try the Tradologie app! https://tradologie.com/app/',
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        /// ACCOUNT SECTION
                        _sectionTitle(context, "ACCOUNT"),

                        _ultraTile(
                          icon: Icons.delete_outline,
                          title: "Delete Account",
                          color: Colors.redAccent,
                          onTap: () async {
                            String? result = await showInputDialog(context);

                            if (result != null && result.isNotEmpty) {
                              if (!context.mounted) return;
                              context.read<AuthenticationCubit>().deleteAccount(
                                    DeleteAccountParams(
                                      token: await secureStorage.read(
                                              AppStrings.apiVerificationCode) ??
                                          "",
                                      message: result,
                                      customerID: Constants.isBuyer
                                          ? await secureStorage.read(
                                                  AppStrings.customerId) ??
                                              ""
                                          : await secureStorage
                                                  .read(AppStrings.vendorId) ??
                                              "",
                                    ),
                                  );
                            }
                          },
                        ),

                        _ultraTile(
                          icon: Icons.logout_rounded,
                          title: "Logout",
                          color: Colors.redAccent,
                          onTap: () {
                            AnalyticsService.logEvent("logout_clicked");
                            context
                                .read<AuthenticationCubit>()
                                .signOut(NoParams());
                          },
                        ),

                        const SizedBox(height: 28),

                        /// UPDATE CTA
                        if (showUpdate)
                          Center(
                            child: GestureDetector(
                              onTap: () => _showUpdateDialog(context, false),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CommonText(
                                    'Newer App Version Available',
                                    style: TextStyleConstants.semiBold(context),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.arrow_forward_ios, size: 14),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: CommonSocialIcons(),
                    ),
                  ),
                ),
              ],
            ),

            /// 🔄 LOADER
            BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                if (state is SignOutIsLoading ||
                    state is DeleteAccountIsLoading) {
                  return const CommonLoader();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, bool isForce) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: CommonText(
          "Update Available",
          style: TextStyleConstants.semiBold(context),
        ),
        content: CommonText(
          "A newer version of the app is available.",
          style: TextStyleConstants.medium(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CommonText(
              "Later",
              style: TextStyleConstants.medium(context),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (Platform.isAndroid) {
                launchUrl(
                    Uri.parse(
                        "https://play.google.com/store/apps/details?id=com.tradologie.app"),
                    mode: LaunchMode.externalApplication);
              }

              if (Platform.isIOS) {
                launchUrl(
                    Uri.parse(
                        "https://apps.apple.com/app/tradologie/id6758596323"),
                    mode: LaunchMode.externalApplication);
              }
            },
            child: CommonText(
              "Update",
              style: TextStyleConstants.semiBold(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withValues(alpha: .05),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.account_circle_rounded, size: 52),
          const SizedBox(width: 14),
          Expanded(
            child: CommonText(
              Constants.name,
              style: TextStyleConstants.semiBold(
                context,
                fontSize: 18,
              ),
            ),
          ),
          IconButton(
            onPressed: Constants.isFmcg ? null : () => _appCubit.changeTab(2),
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CommonText(
        title,
        style: TextStyleConstants.semiBold(
          context,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _ultraTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: color ?? Colors.black87),
              const SizedBox(width: 14),
              Expanded(
                child: CommonText(
                  title,
                  style: TextStyleConstants.medium(context),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
