import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tradologie_app/features/add_negotiation/presentation/cubit/add_negotiation_cubit.dart';
import 'package:tradologie_app/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:tradologie_app/features/webview/presentation/cubit/webview_cubit.dart';

import 'config/routes/app_router.dart';
import 'config/routes/navigation_service.dart';
import 'config/themes/app_theme.dart';
import 'features/app/presentation/cubit/app_cubit.dart';
import 'features/authentication/presentation/cubit/authentication_cubit.dart';
import 'features/dashboard/presentation/cubit/dashboard_cubit.dart';
// import 'features/negotiation/presentation/cubit/negotiation_cubit.dart';
import 'features/negotiation/presentation/cubit/negotiation_cubit.dart';
import 'injection_container.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AppCubit>()..networkConnection()),
        BlocProvider(create: (context) => sl<AuthenticationCubit>()),
        BlocProvider(create: (context) => sl<WebViewCubit>()),
        BlocProvider(create: (context) => sl<DashboardCubit>()),
        BlocProvider(create: (context) => sl<NegotiationCubit>()),
        BlocProvider(create: (context) => sl<MyAccountCubit>()),
        BlocProvider(create: (context) => sl<NotificationCubit>()),
        BlocProvider(create: (context) => sl<AddNegotiationCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppCubit, AppState>(
            listenWhen: (previous, current) {
              return previous != current;
            },
            listener: (context, state) {
              final ctx = sl<NavigationService>().navigationKey.currentContext;
              if (ctx != null) {
                if (state is NetworkConnectState) {
                  // Constants.showConnectInternetSnackbar(context: ctx);
                }
                if (state is NetworkDisconnectState) {
                  // Constants.showErrorInternetSnackbar(context: ctx);
                }
              }
            },
          ),
        ],
        child: BlocBuilder<AppCubit, AppState>(
          buildWhen: (previousState, currentState) {
            return previousState != currentState;
          },
          builder: (context, state) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ),
              child: MaterialApp(
                title: "Tradologie App",
                navigatorKey: sl<NavigationService>().navigationKey,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1)),
                    child: child!,
                  );
                },
                debugShowCheckedModeBanner: false,
                theme: appTheme(context),
                onGenerateRoute: AppRoutes.onGenerateRoute,
              ),
            );
          },
        ),
      ),
    );
  }
}
