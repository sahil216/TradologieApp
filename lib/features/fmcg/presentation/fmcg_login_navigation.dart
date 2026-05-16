import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/nav_cubit.dart';

/// Opens FMCG main on the home tab (not the last visited tab).
void navigateToFmcgMainAfterLogin(BuildContext context) {
  context.read<NavigationCubit>().resetToHomeTab();
  Navigator.pushNamedAndRemoveUntil(
    context,
    Routes.fmcgMainScreen,
    (route) => false,
  );
}
