import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/screens/add_negotiation_details_screen.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/screens/add_product_screen.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/screens/supplier_list_screen.dart';
import 'package:tradologie_app/features/app/presentation/screens/main_screen.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/send_otp_usecase.dart';
import 'package:tradologie_app/features/contact_us/contact_us.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/buyer_dashboard_screen.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/dashboard_screen.dart';
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
        return FadeCupertinoPageRoute(builder: (context) {
          return const SplashScreen();
        });
      case Routes.mainRoute:
        return FadeCupertinoPageRoute(builder: (context) {
          return MainScreen();
        });
      case Routes.onboardingRoute:
        return FadeCupertinoPageRoute(builder: (context) {
          return const OnboardingScreen();
        });
      //! authentication

      case Routes.signinRoute:
        return FadeCupertinoPageRoute(builder: (context) {
          return const SignInScreen();
        });
      case Routes.signupRoute:
        return FadeCupertinoPageRoute(builder: (context) {
          return SignupScreen();
        });

      //! login with whatsapp route
      case Routes.sendOtpScreen:
        return FadeCupertinoPageRoute(builder: (context) {
          return SendOtpScreen();
        });
      case Routes.verifyOtpScreen:
        return FadeCupertinoPageRoute(builder: (context) {
          return VerifyOtpScreen(
            params: routeSettings.arguments as SendOtpParams,
          );
        });

      //! webView
      case Routes.webViewRoute:
        return FadeCupertinoPageRoute(builder: (context) {
          final data = routeSettings.arguments as WebviewParams;
          return WebViewScreen(
            params: data,
          );
        });
      case Routes.inAppWebViewRoute:
        return FadeCupertinoPageRoute(builder: (context) {
          final data = routeSettings.arguments as WebviewParams;
          return InAppWebViewScreen(
            params: data,
          );
        });

      case Routes.termsRoute:
        return FadeCupertinoPageRoute(builder: (context) {
          return TermsScreen(
            initialUrl: routeSettings.arguments as String,
          );
        });

      case Routes.dashboardRoute:
        return FadeCupertinoPageRoute(builder: (context) {
          return const DashboardScreen();
        });
      case Routes.buyerDashboardRoute:
        return FadeCupertinoPageRoute(builder: (context) {
          return const BuyerDashboardScreen();
        });

      case Routes.negotiationScreen:
        return FadeCupertinoPageRoute(builder: (context) {
          return const NegotiationScreen();
        });
      case Routes.supplierListScreen:
        return FadeCupertinoPageRoute(builder: (context) {
          return const SupplierListScreen();
        });
      case Routes.addNegotiationDetailScreen:
        return FadeCupertinoPageRoute(builder: (context) {
          return const AddNegotiationDetailsScreen();
        });
      case Routes.addProductScreen:
        return FadeCupertinoPageRoute(builder: (context) {
          return const AddProductScreen();
        });
      case Routes.buyerNegotiationScreen:
        return FadeCupertinoPageRoute(builder: (context) {
          return const BuyerNegotiationScreen();
        });

      case Routes.myAccountsScreen:
        return FadeCupertinoPageRoute(builder: (context) {
          return const MyAccountScreen();
        });

      case Routes.contactUsScreen:
        return FadeCupertinoPageRoute(
          builder: (context) {
            return const ContactUsScreen();
          },
          fullscreenDialog: false,
        );

      case Routes.notificationScreen:
        return FadeCupertinoPageRoute(builder: (context) {
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
    return FadeCupertinoPageRoute(
      builder: (context) => const AdaptiveScaffold(
        body: Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}

class FadeCupertinoPageRoute<T> extends CupertinoPageRoute<T> {
  FadeCupertinoPageRoute({
    required super.builder,
    super.settings,
    super.fullscreenDialog,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (Platform.isIOS) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.985, end: 1.0).animate(curved),
          child: child,
        ),
      );
    }

    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }
}
