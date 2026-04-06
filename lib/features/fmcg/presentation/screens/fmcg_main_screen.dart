import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/contact_us/more_options_screen.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/chat_list_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_buyer_dashboard_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_my_account_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_seller_dashboard_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/in_app_webview_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import 'package:tradologie_app/features/webview/presentation/screens/webview_screen.dart';

class CommonFMCGFloatingNavBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  final int unreadCount;

  const CommonFMCGFloatingNavBar({
    super.key,
    required this.index,
    required this.onTap,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom, // 🔥 KEY FIX
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (Constants.isBuyer == true) ...[
            _item(0, Icons.dashboard_outlined, "BrandHub"),
            _item(1, Icons.chat_outlined, "Connect"),
            _item(2, Icons.local_grocery_store_outlined, "FMCG"),
            _item(3, Icons.menu_rounded, "More"),
          ] else ...[
            _item(0, Icons.dashboard_outlined, "Dashboard"),
            _item(1, Icons.chat_outlined, "Connect"),
            _item(2, Icons.account_circle_outlined, "Account"),
            _item(3, Icons.menu_rounded, "More"),
            _item(4, Icons.analytics, "Analytics"),
          ]
        ],
      ),
    );
  }

  Widget _item(int i, IconData icon, String label) {
    final bool selected = i == index;
    final bool isChat = label == "Chats";

    const activeColor = Color(0xFF0A9FED);
    const inactiveColor = Colors.black87;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3,
              width: selected ? 20 : 0,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            /// 🔥 ICON WITH BADGE
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? activeColor : inactiveColor,
                ),
                if (isChat && unreadCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FMCGMainScreen extends StatefulWidget {
  const FMCGMainScreen({
    super.key,
  });

  @override
  State<FMCGMainScreen> createState() => _FMCGMainScreenState();
}

class _FMCGMainScreenState extends State<FMCGMainScreen> {
  int currentIndex = 0;

  int unreadCount = 0;
  SecureStorageService secureStorage = SecureStorageService();

  // void updateUnreadCount(List<ChatList> chats) {
  //   unreadCount = chats.fold(0, (sum, chat) {
  //     return sum + (chat.unreadCount ?? 0);
  //   });
  //   setState(() {});
  // }

  Future<void> nameUpdate() async {
    Constants.name = Constants.isFmcg == true
        ? await secureStorage.read(AppStrings.fmcgName) ?? ""
        : Constants.isBuyer == true
            ? await secureStorage.read(AppStrings.customerName) ?? ""
            : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  Future<void> analyticsUpdate() async {
    Constants.analyticsUrl =
        await secureStorage.read(AppStrings.analyticsUrl) ?? "";
  }

  @override
  initState() {
    super.initState();
    nameUpdate();
    analyticsUpdate();
  }

  final List<Widget> screens = [
    FmcgSellerDashboardScreen(),
    ChatListScreen(),
    FmcgMyAccountScreen(),
    MoreOptionsScreen(),
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
    FmcgBuyerDashboardScreen(),
    ChatListScreen(),
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
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: Constants.isBuyer == true
          ? buyerScreens[currentIndex]
          : screens[currentIndex],
      bottomNavigationBar: CommonFMCGFloatingNavBar(
        index: currentIndex,
        onTap: onTabChanged,
        unreadCount: unreadCount,
      ),
    );
  }
}
