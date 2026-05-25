import 'package:flutter/cupertino.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/screens/add_negotiation_details_screen.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/screens/add_product_screen.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/screens/supplier_list_screen.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/viewmodel/add_product_params.dart';
import 'package:tradologie_app/features/app/presentation/screens/main_screen.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/send_otp_usecase.dart';
import 'package:tradologie_app/features/authentication/presentation/screens/fmcg_register_seller_form.dart';
import 'package:tradologie_app/features/authentication/presentation/screens/fmcg_seller_signin.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/chat_list_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/chat_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_main_screen.dart';
import 'package:tradologie_app/features/contact_us/contact_us.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/buyer_dashboard_screen.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/buyer_post_requirement_screen.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/buyer_sell_stock_listing.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/post_stock_requirement_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_products_screen.dart';
import 'package:tradologie_app/features/my_account/presentation/screens/buyer_my_account_screens/add_address_screen.dart';
import 'package:tradologie_app/features/my_account/presentation/screens/buyer_my_account_screens/edit_account_screen.dart';
import 'package:tradologie_app/features/my_account/presentation/screens/my_account_screen.dart';
import 'package:tradologie_app/features/negotiation/presentation/screens/buyer_negotiation_screen.dart';
import 'package:tradologie_app/features/negotiation/presentation/screens/negotiation_screen.dart';

import '../../core/utils/app_strings.dart';
import '../../features/admin/presentation/screens/admin_vendor_chat_screen.dart';
import '../../features/admin/presentation/screens/admin_vendor_conversation_screen.dart';
import '../../features/admin/presentation/screens/select_vendor_chat.dart';
import '../../features/admin/presentation/viewmodel/admin_connect_chat_config.dart';
import '../../features/admin/presentation/viewmodel/admin_vendor_chat_args.dart';
import '../../features/admin/presentation/viewmodel/admin_vendor_conversation_args.dart';
import '../../features/app/presentation/screens/onboarding_screen.dart';
import '../../features/app/presentation/screens/splash_screen.dart';
import '../../features/app/presentation/screens/terms_screen.dart';
import '../../features/authentication/presentation/screens/admin_login.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_verify_otp_screen.dart';
import '../../features/authentication/presentation/screens/send_otp_screen.dart';
import '../../features/authentication/presentation/screens/sign_in_screen.dart';
import '../../features/authentication/presentation/viewmodel/forgot_password_verify_otp_args.dart';
import '../../features/authentication/presentation/screens/sign_up_screen.dart';
import '../../features/authentication/presentation/screens/verify_otp_screen.dart';
import '../../features/fmcg/presentation/screens/ChatbotQueryScreen.dart';
import '../../features/fmcg/presentation/screens/chatbot_tran_screen.dart';
import '../../features/fmcg/presentation/screens/fmcg_quotation_list_screen.dart';
import '../../features/fmcg/presentation/screens/fmcg_quotation_tran_screen.dart';
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
  static const String selectVendorforChat = '/selectVendorforChat';
  static const String adminVendorChat = '/adminVendorChat';
  static const String adminVendorConversation = '/adminVendorConversation';
  static const String adminDirectConnectChat = '/adminDirectConnectChat';
  static const String termsRoute = '/terms';
  static const String onboardingRoute = '/onboarding';
  //! authentication
  static const String otpRoute = '/otp';
  static const String signinRoute = '/signin';
  static const String forgotPasswordRoute = '/forgotPassword';
  static const String forgotPasswordVerifyOtpRoute = '/forgotPasswordVerifyOtp';
  static const String signupRoute = '/signup';
  static const String fmcgSignIn = '/fmcgsignin';
  static const String adminSignin = '/adminSignin';
  static const String fmcgRegisterSellerDistributorForm =
      '/fmcgRegisterSellerDistributorForm';

  //! login with whatsapp route
  static const String sendOtpScreen = '/sendOtpScreen';
  static const String verifyOtpScreen = '/verifyOtpScreen';

  //! webView
  static const String webViewRoute = '/webView';
  static const String inAppWebViewRoute = '/inAppWebView';

  //! Dashboard
  static const String dashboardRoute = '/dashboard';
  static const String buyerDashboardRoute = '/buyerDashboard';
  static const String buyerPostRequirementRoute = '/buyerPostRequirement';
  static const String postStockRequirementScreen =
      '/postStockRequirementScreen';

  static const String buyerSellStockListing = '/buyerSellStockListing';

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
  static const String addAddressScreen = '/addAddressScreen';
  static const String editAccountScreen = '/editAccountScreen';

  //! Contact Us Screen
  static const String contactUsScreen = '/contactUsScreen';
  static const String chatbotqueryscreen = '/chatbotqueryscreen';
  static const String chatbotTranScreen = '/chatbotTranScreen';
  static const String fmcgQuotationListScreen = '/fmcgQuotationListScreen';
  static const String fmcgQuotationTranScreen = '/fmcgQuotationTranScreen';
  //! Notifications
  static const String notificationScreen = '/notificationScreen';

  //! Chat
  static const String chatListScreen = '/chatListScreen';
  static const String chatScreen = '/chatScreen';
  static const String fmcgMainScreen = '/fmcgMainScreen';
  static const String fmcgProductCatalogueRoute = '/fmcgProductCatalogue';
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



      case Routes.selectVendorforChat:
        return CupertinoPageRoute(builder: (context) {
          return SelectVendorforChat();
        });

      case Routes.adminVendorChat:
        return CupertinoPageRoute(builder: (context) {
          final args = routeSettings.arguments as AdminVendorChatArgs;
          return AdminVendorChatScreen(args: args);
        });

      case Routes.adminVendorConversation:
        return CupertinoPageRoute(builder: (context) {
          final args =
              routeSettings.arguments as AdminVendorConversationArgs;
          return AdminVendorConversationScreen(
            vendor: args.vendor,
            chatType1: args.chatType1,
            chatType2: args.chatType2,
            isConnectChat: args.isConnectChat,
          );
        });

      case Routes.adminDirectConnectChat:
        return CupertinoPageRoute(builder: (context) {
          return const AdminVendorConversationScreen(
            vendor: AdminConnectChatConfig.displayVendor,
            chatType1: AdminConnectChatConfig.type1,
            chatType2: AdminConnectChatConfig.type2,
            isConnectChat: true,
          );
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

      case Routes.forgotPasswordRoute:
        return CupertinoPageRoute(builder: (context) {
          return const ForgotPasswordScreen();
        });

      case Routes.forgotPasswordVerifyOtpRoute:
        return CupertinoPageRoute(builder: (context) {
          final args = routeSettings.arguments as ForgotPasswordVerifyOtpArgs;
          return ForgotPasswordVerifyOtpScreen(args: args);
        });

      case Routes.fmcgSignIn:
        return CupertinoPageRoute(builder: (context) {
          final data = routeSettings.arguments as bool;
          return FmcgSellerSignin(
            isBuyer: data,
          );
        });



      case Routes.adminSignin:
        return CupertinoPageRoute(builder: (context) {
          return AdminSignin(
          );
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
      case Routes.fmcgProductCatalogueRoute:
        return CupertinoPageRoute(builder: (context) {
          return FmcgProductsScreen(
            params: routeSettings.arguments as ProductsListParams,
          );
        });
      case Routes.buyerDashboardRoute:
        return CupertinoPageRoute(builder: (context) {
          return const BuyerDashboardScreen();
        });
      case Routes.buyerPostRequirementRoute:
        return CupertinoPageRoute(builder: (context) {
          return const BuyerPostRequirementScreen();
        });
      case Routes.postStockRequirementScreen:
        return CupertinoPageRoute(builder: (context) {
          return const PostStockRequirementScreen();
        });

      case Routes.buyerSellStockListing:
        return CupertinoPageRoute(builder: (context) {
          return const BuyerSellStockListing();
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
      case Routes.addAddressScreen:
        return CupertinoPageRoute(builder: (context) {
          return const AddAddressScreen();
        });
      case Routes.editAccountScreen:
        return CupertinoPageRoute(builder: (context) {
          return const EditAccountScreen();
        });

      case Routes.contactUsScreen:
        return CupertinoPageRoute(
          builder: (context) {
            return const ContactUsScreen();
          },
          fullscreenDialog: false,
        );


          case Routes.chatbotqueryscreen:
        return CupertinoPageRoute(
          builder: (context) {
            return const Chatbotqueryscreen();
          },
          fullscreenDialog: false,
        );

      case Routes.chatbotTranScreen:
        return CupertinoPageRoute(
          builder: (context) {
            final args = routeSettings.arguments as ChatbotTranScreenArgs;
            return ChatbotTranScreen(args: args);
          },
        );

      case Routes.fmcgQuotationListScreen:
        return CupertinoPageRoute(
          builder: (context) => const FmcgQuotationListScreen(),
        );

      case Routes.fmcgQuotationTranScreen:
        return CupertinoPageRoute(
          builder: (context) {
            final args =
                routeSettings.arguments as FmcgQuotationTranScreenArgs;
            return FmcgQuotationTranScreen(args: args);
          },
        );






      case Routes.notificationScreen:
        return CupertinoPageRoute(builder: (context) {
          return const NotificationScreen();
        });
      case Routes.chatListScreen:
        return CupertinoPageRoute(builder: (context) {
          return const ChatListScreen();
        });
      case Routes.fmcgRegisterSellerDistributorForm:
        return CupertinoPageRoute(builder: (context) {
          return FmcgRegisterSellerDistributorForm(
            isDistributor: routeSettings.arguments as bool,
          );
        });
      case Routes.chatScreen:
        return CupertinoPageRoute(builder: (context) {
          return ChatScreen(
            chat: routeSettings.arguments as ChatList,
          );
        });
      case Routes.fmcgMainScreen:
        return CupertinoPageRoute(builder: (context) {
          return FMCGMainScreen();
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
