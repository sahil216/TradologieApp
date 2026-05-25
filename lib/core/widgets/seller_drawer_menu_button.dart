import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/app/presentation/cubit/app_cubit.dart';

/// Hamburger button that opens the seller side drawer on main shell screens.
class SellerDrawerMenuButton extends StatelessWidget {
  final Color? iconColor;
  final double iconSize;

  const SellerDrawerMenuButton({
    super.key,
    this.iconColor,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (Constants.isBuyer) return const SizedBox.shrink();

    return IconButton(
      onPressed: () => context.read<AppCubit>().openSellerDrawer(),
      icon: Icon(
        Icons.menu_rounded,
        color: iconColor ?? Colors.black87,
        size: iconSize,
      ),
    );
  }
}
