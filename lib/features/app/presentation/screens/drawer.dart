import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_social_icons.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/presentation/widgets/input_dialog.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/delete_account_usecase.dart';
import 'package:tradologie_app/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_products_mycatalogue.dart';
import 'package:tradologie_app/features/my_account/presentation/screens/my_account_screen.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../injection_container_app.dart';

/// Seller side drawer — More options + My Account (not in bottom bar).
class SellerSideDrawer extends StatefulWidget {
  const SellerSideDrawer({super.key});

  @override
  State<SellerSideDrawer> createState() => _SellerSideDrawerState();
}

class _SellerSideDrawerState extends State<SellerSideDrawer> {
  final SecureStorageService secureStorage = SecureStorageService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: AdaptiveScaffold(
        useSafeArea: true,
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthenticationCubit, AuthenticationState>(
              listenWhen: (previous, current) => previous != current,
              listener: (context, state) {
                if (state is SignOutSuccess) {
                  CommonToast.success('Signed Out Successfully');
                  Constants.isLogin = false;
                  Constants.isFmcg = false;
                  Constants.isAdmin = false;
                  final storage = SecureStorageService();
                  storage.delete(AppStrings.apiVerificationCode);
                  Constants.token = '';
                  storage.write(AppStrings.isFmcg, false.toString());
                  storage.write(AppStrings.isAdmin, 'false');
                  storage.write(AppStrings.appSession, false.toString());
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
          ],
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.fromLTRB(
                  8,
                  MediaQuery.of(context).padding.top + 28,
                  8,
                  24,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                    child: Image.asset(
                      ImgAssets.companyLogo,
                      height: 36,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.account_circle_rounded,
                      size: 40,
                    ),
                    title: Text(
                      Constants.name,
                      style: TextStyleConstants.semiBold(
                        context,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'View profile',
                      style: TextStyleConstants.regular(
                        context,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () => _openMyAccount(context),
                  ),
                  const Divider(height: 24),
                  _sectionLabel(context, 'GENERAL'),
                  _DrawerItem(
                    icon: Icons.person_outline,
                    title: 'My Account',
                    onTap: () => _openMyAccount(context),
                  ),
                  _DrawerItem(
                    icon: Icons.support_agent_outlined,
                    title: 'Contact Us',
                    onTap: () {
                      Navigator.pop(context);
                      sl<NavigationService>().pushNamed(Routes.contactUsScreen);
                    },
                  ),
                  if (Constants.isFmcg && !Constants.isBuyer) ...[
                    _DrawerItem(
                      icon: Icons.query_stats_outlined,
                      title: 'Chat Bot Queries',
                      onTap: () {
                        Navigator.pop(context);
                        sl<NavigationService>()
                            .pushNamed(Routes.chatbotqueryscreen);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.badge_rounded,
                      title: 'My Catalogue',
                      onTap: () async {
                        Navigator.pop(context);
                        final brandId =
                            await secureStorage.read(AppStrings.brandId) ?? '0';
                        final storedBrandName =
                            await secureStorage.read(AppStrings.brandName);
                        final brandName = (storedBrandName != null &&
                                storedBrandName.isNotEmpty)
                            ? storedBrandName
                            : (await secureStorage.read(AppStrings.fmcgName)) ??
                                '';
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FmcgProductsMycatalogue(
                              params: ProductsListMyCatalogueParams(
                                brandId: brandId,
                                brandName: brandName,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.receipt_long_outlined,
                      title: 'Quotation List',
                      onTap: () {
                        Navigator.pop(context);
                        sl<NavigationService>()
                            .pushNamed(Routes.fmcgQuotationListScreen);
                      },
                    ),
                  ],
                  _DrawerItem(
                    icon: Icons.share_outlined,
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
                  const Divider(height: 24),
                  _sectionLabel(context, 'ACCOUNT'),
                  _DrawerItem(
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    titleColor: Colors.redAccent,
                    onTap: () async {
                      final result = await showInputDialog(context);
                      if (result != null && result.isNotEmpty) {
                        if (!context.mounted) return;
                        context.read<AuthenticationCubit>().deleteAccount(
                              DeleteAccountParams(
                                token: await secureStorage.read(
                                      AppStrings.apiVerificationCode,
                                    ) ??
                                    '',
                                message: result,
                                customerID: await secureStorage.read(
                                      AppStrings.vendorId,
                                    ) ??
                                    '',
                              ),
                            );
                      }
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.power_settings_new,
                    title: 'Logout',
                    titleColor: Colors.redAccent,
                    onTap: () {
                      context.read<AuthenticationCubit>().signOut(NoParams());
                    },
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CommonSocialIcons(),
                  ),
                ],
              ),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                buildWhen: (previous, current) {
                  return current is SignOutIsLoading ||
                      current is DeleteAccountIsLoading;
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
    );
  }

  void _openMyAccount(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MyAccountScreen()),
    );
  }

  Widget _sectionLabel(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black38,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// @deprecated Use [SellerSideDrawer]. Kept for imports that still reference this name.
typedef TradologieDrawer = SellerSideDrawer;

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 24, color: titleColor ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: titleColor ?? Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.black26),
      onTap: onTap,
    );
  }
}
