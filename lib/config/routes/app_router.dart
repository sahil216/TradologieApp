import 'package:flutter/cupertino.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/screens/add_negotiation_details_screen.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/screens/add_product_screen.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/screens/supplier_list_screen.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/viewmodel/add_product_params.dart';
import 'package:tradologie_app/features/app/presentation/screens/main_screen.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/send_otp_usecase.dart';
import 'package:tradologie_app/features/contact_us/contact_us.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/buyer_dashboard_screen.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/post_stock_requirement_screen.dart';
import 'package:tradologie_app/features/my_account/presentation/screens/my_account_screen.dart';
import 'package:tradologie_app/features/negotiation/presentation/screens/buyer_negotiation_screen.dart';
import 'package:tradologie_app/features/negotiation/presentation/screens/negotiation_screen.dart';

import '../../core/utils/app_strings.dart';
import '../../features/app/presentation/screens/onboarding_screen.dart';
import '../../features/app/presentation/screens/splash_screen.dart';
import '../../features/app/presentation/screens/terms_screen.dart';
import '../../features/authentication/presentation/screens/send_otp_screen.dart';
import '../../features/authentication/presentation/screens/sign_in_screen.dart';
import '../../features/authentication/presentation/screens/sign_up_screen.dart';
import '../../features/authentication/presentation/screens/verify_otp_screen.dart';
import '../../features/notification/presentation/screens/notification_screen.dart';
import '../../features/webview/presentation/screens/in_app_webview_screen.dart';
import '../../features/webview/presentation/screens/viewmodel/webview_params.dart';
import '../../features/webview/presentation/screens/webview_screen.dart';

class Routes {
  //! account
  static const String accountRoute = '/account';
  static const String addressRoute = '/address';
  static const String profileRoute = '/profile';
  static const String chooseLocationRoute = '/chooseLocation';
  //! app
  static const String initialRoute = '/';
  static const String mainRoute = '/main';
  static const String termsRoute = '/terms';
  static const String onboardingRoute = '/onboarding';
  //! authentication
  static const String otpRoute = '/otp';
  static const String signinRoute = '/signin';
  static const String signupRoute = '/signup';

  //! login with whatsapp route
  static const String sendOtpScreen = '/sendOtpScreen';
  static const String verifyOtpScreen = '/verifyOtpScreen';

  //! webView
  static const String webViewRoute = '/webView';
  static const String inAppWebViewRoute = '/inAppWebView';

  //! Dashboard
  static const String dashboardRoute = '/dashboard';
  static const String buyerDashboardRoute = '/buyerDashboard';
  static const String postStockRequirementScreen =
      '/postStockRequirementScreen';

  //! Negotiation
  static const String negotiationScreen = '/negotiationScreen';
  static const String buyerNegotiationScreen = '/buyerNegotiationScreen';

  //! Add Negotiation
  static const String supplierListScreen = '/supplierListScreen';
  static const String addNegotiationDetailScreen =
      '/addNegotiationDetailScreen';
  static const String addProductScreen = '/addProductScreen';

  //! MyAccounts
  static const String myAccountsScreen = '/myAccountsScreen';
  //! Contact Us Screen
  static const String contactUsScreen = '/contactUsScreen';
  //! Notifications
  static const String notificationScreen = '/notificationScreen';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      //! app
      case Routes.initialRoute:
        return CupertinoPageRoute(builder: (context) {
          return const SplashScreen();
        });
      case Routes.mainRoute:
        return CupertinoPageRoute(builder: (context) {
          return MainScreen();
        });
      case Routes.onboardingRoute:
        return CupertinoPageRoute(builder: (context) {
          return const OnboardingScreen();
        });
      //! authentication

      case Routes.signinRoute:
        return CupertinoPageRoute(builder: (context) {
          return const SignInScreen();
        });
      case Routes.signupRoute:
        return CupertinoPageRoute(builder: (context) {
          return SignupScreen();
        });

      //! login with whatsapp route
      case Routes.sendOtpScreen:
        return CupertinoPageRoute(builder: (context) {
          return SendOtpScreen();
        });
      case Routes.verifyOtpScreen:
        return CupertinoPageRoute(builder: (context) {
          return VerifyOtpScreen(
            params: routeSettings.arguments as SendOtpParams,
          );
        });

      //! webView
      case Routes.webViewRoute:
        return CupertinoPageRoute(builder: (context) {
          final data = routeSettings.arguments as WebviewParams;
          return WebViewScreen(
            params: data,
          );
        });
      case Routes.inAppWebViewRoute:
        return CupertinoPageRoute(builder: (context) {
          final data = routeSettings.arguments as WebviewParams;
          return InAppWebViewScreen(
            params: data,
          );
        });

      case Routes.termsRoute:
        return CupertinoPageRoute(builder: (context) {
          return TermsScreen(
            initialUrl: routeSettings.arguments as String,
          );
        });

      case Routes.dashboardRoute:
        return CupertinoPageRoute(builder: (context) {
          return const DashboardScreen();
        });
      case Routes.buyerDashboardRoute:
        return CupertinoPageRoute(builder: (context) {
          return const BuyerDashboardScreen();
        });
      case Routes.postStockRequirementScreen:
        return CupertinoPageRoute(builder: (context) {
          return const PostStockRequirementScreen();
        });

      case Routes.negotiationScreen:
        return CupertinoPageRoute(builder: (context) {
          return const NegotiationScreen();
        });
      case Routes.supplierListScreen:
        return CupertinoPageRoute(builder: (context) {
          return const SupplierListScreen();
        });
      case Routes.addNegotiationDetailScreen:
        return CupertinoPageRoute(builder: (context) {
          final params = routeSettings.arguments as AddProductParams;
          return AddNegotiationDetailsScreen(params: params);
        });
      case Routes.addProductScreen:
        return CupertinoPageRoute(builder: (context) {
          final params = routeSettings.arguments as AddProductParams;
          return AddProductScreen(
            params: params,
          );
        });
      case Routes.buyerNegotiationScreen:
        return CupertinoPageRoute(builder: (context) {
          return const BuyerNegotiationScreen();
        });

      case Routes.myAccountsScreen:
        return CupertinoPageRoute(builder: (context) {
          return const MyAccountScreen();
        });

      case Routes.contactUsScreen:
        return CupertinoPageRoute(
          builder: (context) {
            return const ContactUsScreen();
          },
          fullscreenDialog: false,
        );

      case Routes.notificationScreen:
        return CupertinoPageRoute(builder: (context) {
          return const NotificationScreen();
        });

      default:
        return undefinedRoute();
    }
  }

  static Widget? getPage(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mainRoute:
        return const MainScreen();

      default:
        return null;
    }
  }

  static Route<dynamic> undefinedRoute() {
    return CupertinoPageRoute(
      builder: (context) => const AdaptiveScaffold(
        body: Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}
