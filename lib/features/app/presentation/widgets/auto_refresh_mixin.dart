import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/features/app/presentation/cubit/app_cubit.dart';

// mixin TabAutoRefreshMixin<T extends StatefulWidget> on State<T> {
//   late AppCubit _appCubit;
//   late int _tabIndex;

//   /// 🔥 override this in screen
//   void onTabActive();

//   /// 🔥 provide tab index from MainScreen order
//   int get tabIndex;

//   @override
//   void initState() {
//     super.initState();

//     _appCubit = context.read<AppCubit>();
//     _tabIndex = tabIndex;

//     /// Listen globally to tab change
//     _appCubit.stream.listen((state) {
//       if (!mounted) return;

//       if (_appCubit.bottomNavIndex == _tabIndex) {
//         onTabActive();
//       }
//     });
//   }
// }
