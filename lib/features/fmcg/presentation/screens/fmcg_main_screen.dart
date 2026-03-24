import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/features/contact_us/more_options_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/chat_list_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_account_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_distributor_enq.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_my_account_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_seller_dashboard_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/in_app_webview_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import 'package:tradologie_app/features/webview/presentation/screens/webview_screen.dart';

class CommonFMCGFloatingNavBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const CommonFMCGFloatingNavBar({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .75),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withValues(alpha: .08),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (Constants.isBuyer == true) ...[
                  _item(0, Icons.dashboard_outlined, "Dashboard"),
                  _item(1, Icons.menu_rounded, "More"),
                ] else ...[
                  _item(0, Icons.dashboard_outlined, "Dashboard"),
                  _item(1, Icons.chat_outlined, "Chats"),
                  _item(2, Icons.account_circle_outlined, "Account"),
                  _item(3, Icons.menu_rounded, "More"),
                  _item(4, Icons.payment_outlined, "Membership"),
                  _item(5, Icons.analytics, "Analytics"),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int i, IconData icon, String label) {
    final bool active = i == index;

    return GestureDetector(
      onTap: () => onTap(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: active ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? Colors.white : Colors.black54,
            ),
            if (active) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class FMCGMainScreen extends StatefulWidget {
  const FMCGMainScreen({super.key});

  @override
  State<FMCGMainScreen> createState() => _FMCGMainScreenState();
}

class _FMCGMainScreenState extends State<FMCGMainScreen> {
  int currentIndex = 0;

  SecureStorageService secureStorage = SecureStorageService();

  Future<void> nameUpdate() async {
    Constants.name = Constants.isFmcg == true
        ? await secureStorage.read(AppStrings.fmcgName) ?? ""
        : Constants.isBuyer == true
            ? await secureStorage.read(AppStrings.customerName) ?? ""
            : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  @override
  initState() {
    super.initState();
    nameUpdate();
  }

  final List<Widget> screens = [
    FmcgSellerDashboardScreen(),
    ChatListScreen(),
    FmcgMyAccountScreen(),
    MoreOptionsScreen(),
    SizedBox(),
    Constants.isAndroid14OrBelow && Platform.isAndroid
        ? InAppWebViewScreen(
            params: WebviewParams(
                url: Constants.analyticsUrl, canPop: false, isAppBar: true))
        : WebViewScreen(
            params: WebviewParams(
            url: Constants.analyticsUrl,
            canPop: false,
            isAppBar: true,
          )),
  ];
  final List<Widget> buyerScreens = [
    Constants.isAndroid14OrBelow && Platform.isAndroid
        ? InAppWebViewScreen(
            params: WebviewParams(
                url: "https://www.tradologie.com/fmcg-view",
                canPop: false,
                isAppBar: true))
        : WebViewScreen(
            params: WebviewParams(
            url: "https://www.tradologie.com/fmcg-view",
            canPop: false,
            isAppBar: true,
          )),
    MoreOptionsScreen(),
  ];

  void onTabChanged(int index) {
    setState(() {
      if (index == 4) {
        Constants.launch("https://www.tradologie.com/brand-membership/");
      } else {
        setState(() {
          currentIndex = index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Constants.isBuyer == true
                ? buyerScreens[currentIndex]
                : screens[currentIndex],
            CommonFMCGFloatingNavBar(
              index: currentIndex,
              onTap: onTabChanged,
            ),
          ],
        ),
      ),
    );
  }
}
