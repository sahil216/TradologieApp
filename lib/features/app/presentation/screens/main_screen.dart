import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/svg.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/custom_icon_button.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/constants.dart';
import '../cubit/app_cubit.dart';
import '../view_model/tab_view_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late AppCubit _appCubit;

  final _firstListTab = [
    TabViewModel(
      icon: VectorAssets.home,
      name: 'home',
      height: 26,
      page: Container(), // const HomePage(),
    ),
    TabViewModel(
      icon: VectorAssets.orders,
      name: 'my_requests',
      height: 20,
      page: Container(), // const OrdersScreen(),
    ),
  ];
  final _secondListTab = [
    TabViewModel(
      icon: VectorAssets.cars,
      name: 'my_cars',
      height: 26,
      page: Container(), //const Cars(),
    ),
    TabViewModel(
      icon: VectorAssets.trolley,
      name: 'my_purchases',
      height: 20,
      page: Container(), // const MyPurchasesPage(),
    ),
  ];

  @override
  void initState() {
    _appCubit = BlocProvider.of<AppCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) =>
          (previous != current && current is ChangeTab),
      builder: (context, state) {
        return PopScope(
          canPop: _appCubit.bottomNavIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (_appCubit.bottomNavIndex != 0) {
              _appCubit.changeTab(0);
            }
          },
          child: AdaptiveScaffold(
            appBar: Constants.appBar(context, height: 0, boxShadow: []),
            bottomNavigationBar: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 100,
                  padding: EdgeInsets.only(left: 27, right: 27, bottom: 18),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(-5, 0),
                        color: AppColors.black.withValues(alpha: 0.07),
                      ),
                    ],
                  ),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ..._firstListTab.mapIndexed(
                          (index, item) => GestureDetector(
                            onTap: () {
                              // if (_appCubit.bottomNavIndex != index) {
                              //   if (item.page is OrdersScreen &&
                              //       !Constants.isLogin) {
                              //     Constants.showWarningDialog(
                              //       context: context,
                              //       msg: context
                              //           .translate("this_step_requires_login"),
                              //       onClickYes: () {
                              //         Navigator.pop(context);
                              //         Navigator.pushNamed(
                              //             context, Routes.authRoute);
                              //       },
                              //     );
                              //     return;
                              //   }
                              //   _appCubit.changeTab(index);
                              // }
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    item.icon,
                                    height: 29,
                                    colorFilter: ColorFilter.mode(
                                      _appCubit.bottomNavIndex == index
                                          ? AppColors.primary
                                          : AppColors.grayText,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    (item.name),
                                    style: TextStyleConstants.medium(
                                      context,
                                      fontSize: 11,
                                      color: _appCubit.bottomNavIndex == index
                                          ? AppColors.black
                                          : AppColors.grayText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        ..._secondListTab.mapIndexed(
                          (index, item) => GestureDetector(
                            onTap: () {
                              if (_appCubit.bottomNavIndex !=
                                  index + _firstListTab.length) {
                                if (!Constants.isLogin) {
                                  Constants.showWarningDialog(
                                    context: context,
                                    msg: "this_step_requires_login",
                                    onClickYes: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, Routes.signinRoute);
                                    },
                                  );
                                  return;
                                }

                                _appCubit
                                    .changeTab(index + _firstListTab.length);
                              }
                            },
                            child: Container(
                              color: AppColors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    item.icon,
                                    height: 29,
                                    colorFilter: ColorFilter.mode(
                                      _appCubit.bottomNavIndex ==
                                              index + _firstListTab.length
                                          ? AppColors.primary
                                          : AppColors.grayText,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Text(
                                    (item.name),
                                    style: TextStyleConstants.medium(
                                      context,
                                      fontSize: 11,
                                      color: _appCubit.bottomNavIndex ==
                                              index + _firstListTab.length
                                          ? AppColors.black
                                          : AppColors.grayText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -18,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconButton(
                        onPressed: () {
                          // if (!Constants.isLogin) {
                          //   Constants.showWarningDialog(
                          //     context: context,
                          //     msg:
                          //          ("this_step_requires_login"),
                          //     onClickYes: () {
                          //       Navigator.pop(context);
                          //       Navigator.pushNamed(context, Routes.authRoute);
                          //     },
                          //   );
                          // } else {
                          //   Navigator.pushNamed(
                          //       context, Routes.partsPricingServiceRoute);
                          // }
                        },
                        height: 60,
                        width: 60,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: const Offset(0, -30),
                            color: AppColors.black.withValues(alpha: 0.03),
                          ),
                        ],
                        border: Border.all(
                          width: 4,
                          color: AppColors.white,
                        ),
                        icon: VectorAssets.plus,
                        shape: BoxShape.circle,
                        backgroundColor: AppColors.primary,
                      ),
                      Text(
                        ("new_request"),
                        style: TextStyleConstants.medium(
                          context,
                          fontSize: 11,
                          color: AppColors.grayText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: PageView(
              controller: _appCubit.controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ..._firstListTab.map((e) => e.page),
                ..._secondListTab.map((e) => e.page),
              ],
            ),
          ),
        );
      },
    );
  }
}
