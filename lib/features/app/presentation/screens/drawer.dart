import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_social_icons.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/domain/usecases/check_force_update_usecase.dart';
import 'package:tradologie_app/features/app/presentation/cubit/app_cubit.dart';
import 'package:tradologie_app/features/app/presentation/widgets/input_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../authentication/domain/usecases/delete_account_usecase.dart';
import '../../../authentication/presentation/cubit/authentication_cubit.dart';

class TradologieDrawer extends StatefulWidget {
  const TradologieDrawer({super.key});

  @override
  State<TradologieDrawer> createState() => _TradologieDrawerState();
}

class _TradologieDrawerState extends State<TradologieDrawer> {
  SecureStorageService secureStorage = SecureStorageService();

  String name = "";
  bool showUpdate = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVersion();
      getName();
    });
  }

  Future<void> _checkVersion() async {
    final version = await getAppVersion();
    context.read<AppCubit>().checkForceUpdate(
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
    return name = Constants.isBuyer == true
        ? await secureStorage.read(AppStrings.customerName) ?? ""
        : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: AdaptiveScaffold(
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              BlocListener<AuthenticationCubit, AuthenticationState>(
                listenWhen: (previous, current) => previous != current,
                listener: (context, state) {
                  if (state is SignOutSuccess) {
                    Constants.showSuccessToast(
                      context: context,
                      msg: "Signed Out Successfully",
                    );
                    Constants.isLogin = false;
                    SecureStorageService secureStorage = SecureStorageService();
                    secureStorage.delete(AppStrings.apiVerificationCode);
                    secureStorage.write(
                        AppStrings.appSession, false.toString());

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.onboardingRoute,
                      (route) => false, // removes all previous routes
                    );
                  }
                  if (state is SignOutError) {
                    Constants.showFailureToast(state.failure);
                  }
                  if (state is DeleteAccountSuccess) {
                    BlocProvider.of<AuthenticationCubit>(context)
                        .signOut(NoParams());
                  }
                  if (state is DeleteAccountError) {
                    Constants.showFailureToast(state.failure);
                  }
                },
              ),
              BlocListener<AppCubit, AppState>(
                listenWhen: (previous, current) => previous != current,
                listener: (context, state) {
                  if (state is CheckForceUpdateSuccess) {
                    setState(() {
                      showUpdate = false;
                    });
                  }
                  if (state is CheckForceUpdateError) {
                    setState(() {
                      showUpdate = true;
                    });
                  }
                },
              ),
            ],
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                      child: Image.asset(
                        ImgAssets.companyLogo, // replace with your logo
                        height: 36,
                      ),
                    ),

                    const Divider(),
                    ListTile(
                        leading: Icon(
                          Icons.account_circle_rounded,
                          size: 40,
                        ),
                        title: Text(
                          name,
                          style: TextStyleConstants.semiBold(context,
                              fontSize: 16),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            Routes.myAccountsScreen,
                          );
                        }),

                    // Menu Items

                    _DrawerItem(
                        onTap: () async {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            Routes.myAccountsScreen,
                          );
                          // SecureStorageService secureStorage = SecureStorageService();

                          // Navigator.pushReplacementNamed(context, Routes.webViewRoute,
                          //     arguments: WebviewParams(
                          //   url: Uri.parse(
                          //     "${EndPoints.supplierImageurl}/Mobile_login.aspx",
                          //   ).replace(
                          //     queryParameters: {
                          //       "VendorNAME": await secureStorage.read(
                          //         AppStrings.vendorName,
                          //       ),
                          //       "VendorID": await secureStorage.read(
                          //         AppStrings.vendorId,
                          //       ),
                          //       "ImageExist": await secureStorage.read(
                          //         AppStrings.imageExist,
                          //       ),
                          //       "SellerTimeZone": await secureStorage.read(
                          //         AppStrings.sellerTimeZone,
                          //       ),
                          //       "RegistrationStatus": await secureStorage.read(
                          //         AppStrings.registrationStatus,
                          //       ),
                          //       "Project_Type": await secureStorage.read(
                          //         AppStrings.projectType,
                          //       ),
                          //     },
                          //   ).toString(),
                          //   isAppBar: false,
                          //   canPop: true,
                          // ));
                        },
                        iconPath: Icon(Icons.account_circle_outlined, size: 24),
                        title: 'My Account'),

                    _DrawerItem(
                      iconPath: Image.asset(ImgAssets.dashboard,
                          width: 24, height: 24),
                      title: 'Dashboard',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.dashboardRoute,
                        );
                      },
                    ),
                    _DrawerItem(
                      onTap: () async {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          Routes.negotiationScreen,
                        );
                      },
                      iconPath: Image.asset(ImgAssets.negotiation,
                          width: 24, height: 24),
                      title: 'Negotiation',
                    ),
                    // _DrawerItem(
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //     },
                    //     iconPath: ImgAssets.negotitationOrderHistory,
                    //     title: 'Negotiation Order History'),
                    // _DrawerItem(
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //     },
                    //     iconPath: ImgAssets.bulk,
                    //     title: "Bulk"),
                    // _DrawerItem(
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //     },
                    //     iconPath: ImgAssets.orders,
                    //     title: 'Orders'),
                    // _DrawerItem(
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //     },
                    //     iconPath: ImgAssets.accounts,
                    //     title: 'Accounts'),
                    // _DrawerItem(
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //     },
                    //     iconPath: ImgAssets.analysisReports,
                    //     title: 'Analysis/Reports'),
                    _DrawerItem(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, Routes.contactUsScreen);
                        },
                        iconPath: Icon(Icons.account_circle_outlined, size: 24),
                        title: 'Contact Us'),
                    _DrawerItem(
                        onTap: () {
                          SharePlus.instance.share(ShareParams(
                              text:
                                  'Check out Tradologie App https://tradologie.com/app/'));
                        },
                        iconPath: Icon(Icons.share, size: 24),
                        title: 'Share App'),

                    _DrawerItem(
                        onTap: () async {
                          String? result = await showInputDialog(context);

                          if (result != null && result.isNotEmpty) {
                            BlocProvider.of<AuthenticationCubit>(context)
                                .deleteAccount(
                              DeleteAccountParams(
                                  token: await secureStorage.read(
                                        AppStrings.apiVerificationCode,
                                      ) ??
                                      "",
                                  message: result,
                                  customerID: Constants.isBuyer == true
                                      ? await secureStorage.read(
                                            AppStrings.customerId,
                                          ) ??
                                          ""
                                      : await secureStorage.read(
                                            AppStrings.vendorId,
                                          ) ??
                                          ""),
                            );
                          }
                        },
                        iconPath: Icon(Icons.delete_outline, size: 24),
                        title: 'Delete Account'),
                    _DrawerItem(
                        onTap: () {
                          BlocProvider.of<AuthenticationCubit>(context)
                              .signOut(NoParams());
                        },
                        iconPath: Image.asset(ImgAssets.logout,
                            width: 24, height: 24),
                        title: 'Logout'),
                    Spacer(),
                    showUpdate == false
                        ? SizedBox.shrink()
                        : GestureDetector(
                            onTap: () => _showUpdateDialog(context, false),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonText(
                                  'Newer App Version Available',
                                  style: TextStyleConstants.semiBold(context),
                                ),
                                Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                          ),

                    CommonSocialIcons(),

                    // Follow us
                  ],
                ),
                BlocBuilder<AuthenticationCubit, AuthenticationState>(
                  buildWhen: (previous, current) {
                    bool result = current != previous;

                    result = result &&
                        (current is SignOutIsLoading ||
                            current is SignOutSuccess ||
                            current is SignOutError ||
                            current is DeleteAccountIsLoading ||
                            current is DeleteAccountSuccess ||
                            current is DeleteAccountError);

                    return result;
                  },
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
                    Uri.parse("https://testflight.apple.com/join/sffC3HPU"),
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
}

class _DrawerItem extends StatelessWidget {
  final Widget iconPath;

  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: iconPath,
      title: Text(title),
      onTap: onTap,
    );
  }
}
