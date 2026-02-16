import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_social_icons.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/presentation/cubit/app_cubit.dart';
import 'package:tradologie_app/features/app/presentation/screens/drawer.dart';
import 'package:tradologie_app/features/app/presentation/widgets/auto_refresh_mixin.dart';
import 'package:tradologie_app/features/app/presentation/widgets/input_dialog.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/delete_account_usecase.dart';
import 'package:tradologie_app/features/authentication/presentation/cubit/authentication_cubit.dart';

import '../../injection_container.dart';

class MoreOptionsScreen extends StatefulWidget {
  const MoreOptionsScreen({super.key});

  @override
  State<MoreOptionsScreen> createState() => _MoreOptionsScreenState();
}

class _MoreOptionsScreenState extends State<MoreOptionsScreen> {
  SecureStorageService secureStorage = SecureStorageService();

  String name = "";
  bool showUpdate = false;

  late AppCubit _appCubit;

  // @override
  // int get tabIndex => 4;

  // @override
  // void onTabActive() {
  //   // clearForm();
  //   // getCommodityData(); // 🔥 auto refresh
  // }

  @override
  void initState() {
    super.initState();
    // _appCubit = context.read<AppCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                  child: Image.asset(
                    ImgAssets.companyLogo,
                    height: 36,
                  ),
                ),

                /// USER TILE
                ListTile(
                  leading: const Icon(Icons.account_circle_rounded, size: 40),
                  title: Text(
                    Constants.name,
                    style: TextStyleConstants.semiBold(context, fontSize: 16),
                  ),
                  onTap: () {
                    _appCubit.changeTab(2);
                  },
                ),

                /// MENU ITEMS
                DrawerItem(
                  iconPath: const Icon(Icons.contact_support_outlined),
                  title: 'Contact Us',
                  onTap: () {
                    sl<NavigationService>().pushNamed(Routes.contactUsScreen);
                  },
                ),

                DrawerItem(
                  iconPath: const Icon(Icons.share),
                  title: 'Share App',
                  onTap: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text:
                            '${Constants.name} invited you to try the Tradologie app! https://tradologie.com/app/',
                      ),
                    );
                  },
                ),

                DrawerItem(
                  iconPath: const Icon(Icons.delete_outline),
                  title: 'Delete Account',
                  onTap: () async {
                    String? result = await showInputDialog(context);

                    if (result != null && result.isNotEmpty) {
                      context.read<AuthenticationCubit>().deleteAccount(
                            DeleteAccountParams(
                              token: await secureStorage
                                      .read(AppStrings.apiVerificationCode) ??
                                  "",
                              message: result,
                              customerID: Constants.isBuyer
                                  ? await secureStorage
                                          .read(AppStrings.customerId) ??
                                      ""
                                  : await secureStorage
                                          .read(AppStrings.vendorId) ??
                                      "",
                            ),
                          );
                    }
                  },
                ),

                DrawerItem(
                  iconPath:
                      Image.asset(ImgAssets.logout, width: 24, height: 24),
                  title: 'Logout',
                  onTap: () {
                    context.read<AuthenticationCubit>().signOut(NoParams());
                  },
                ),

                const Spacer(),

                if (showUpdate)
                  GestureDetector(
                    onTap: () => _showUpdateDialog(context, false),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonText(
                          'Newer App Version Available',
                          style: TextStyleConstants.semiBold(context),
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),

                const CommonSocialIcons(),
              ],
            ),

            /// LOADER
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
    // SAME METHOD AS YOUR DRAWER
  }
}
