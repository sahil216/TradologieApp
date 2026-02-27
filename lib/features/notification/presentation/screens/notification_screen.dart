import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/notification/presentation/cubit/notification_cubit.dart';

import '../../../../core/error/network_failure.dart';
import '../../../../core/error/user_failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../domain/entities/notification_detail.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  List<NotificationDetail>? data;

  NotificationCubit get cubit => BlocProvider.of<NotificationCubit>(context);

  Future<void> getInformation() async {
    await cubit.getNotification(NoParams());
  }

  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;
  @override
  void initState() {
    super.initState();
    getInformation();
    _screenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _screenFade = CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    );

    _screenScale = Tween<double>(
      begin: 0.97,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    _screenSlide = Tween<Offset>(
      begin: const Offset(0, .04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _screenController.forward();
    });
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationCubit, NotificationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is NotificationSuccess) {
              data = [...state.data];

              /// ⭐ SORT BY DATE DESCENDING (LATEST FIRST)
              data!.sort((a, b) {
                final DateTime dateA =
                    DateTime.tryParse(a.updatedDate ?? "") ?? DateTime(1970);
                final DateTime dateB =
                    DateTime.tryParse(b.updatedDate ?? "") ?? DateTime(1970);

                return dateB.compareTo(dateA); // 👈 DESCENDING
              });
            }
            if (state is NotificationError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: AdaptiveScaffold(
        body: BlocBuilder<NotificationCubit, NotificationState>(
          buildWhen: (previous, current) {
            bool result = previous != current;
            result = result &&
                (current is NotificationSuccess ||
                    current is NotificationError ||
                    current is NotificationIsLoading);
            return result;
          },
          builder: (context, state) {
            /// 🔄 FIRST LOAD / ERROR STATES
            if (data == null) {
              if (state is NotificationError) {
                if (state.failure is NetworkFailure) {
                  return CustomErrorNetworkWidget(
                    onPress: () {
                      getInformation();
                    },
                  );
                } else if (state.failure is UserFailure) {
                  return CustomErrorWidget(
                    onPress: () {
                      getInformation();
                    },
                    errorText: state.failure.msg,
                  );
                }
              }
              return const CommonLoader();
            }

            /// 💎 SLIVER STRUCTURE
            return FadeTransition(
                opacity: _screenFade,
                child: SlideTransition(
                    position: _screenSlide,
                    child: ScaleTransition(
                        scale: _screenScale,
                        child: CustomScrollView(
                          slivers: [
                            const CommonAppbar(
                              title: "Notification",
                              showBackButton: true,
                            ),
                            if (data!.isEmpty)
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: _emptyState(),
                              )
                            else

                              /// 🔔 LIST
                              SliverPadding(
                                padding: const EdgeInsets.all(16),
                                sliver: SliverList.separated(
                                  itemCount: data?.length ?? 0,
                                  separatorBuilder: (_, __) => const Divider(),
                                  itemBuilder: (context, index) {
                                    return _notificationTile(data![index]);
                                  },
                                ),
                              ),
                          ],
                        ))));
          },
        ),
      ),
    );
  }

  Widget _notificationTile(NotificationDetail notification) {
    // final bool isUnread = !(notification.isRead ?? true);

    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 450),
        tween: Tween(begin: 0.95, end: 1),
        curve: Curves.easeOutCubic,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),

              /// 💎 ULTRA GLASS BACKGROUND
              color: Colors.white.withValues(alpha: .85),

              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: Colors.black.withValues(alpha: .05),
                ),
              ],

              border: Border.all(
                color: Colors.black.withValues(alpha: .04),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔵 UNREAD DOT (ANIMATED)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  // width: isUnread ? 10 : 0,
                  // height: isUnread ? 10 : 0,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),

                /// 📄 CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        notification.contentTitle ?? "",
                        style: TextStyleConstants.semiBold(
                          context,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      CommonText(
                        notification.contentText ?? "",
                        style: TextStyleConstants.medium(
                          context,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          CommonText(
                            Constants.dateFormat(
                              DateTime.parse(
                                notification.updatedDate ?? "",
                              ),
                            ),
                            style: TextStyleConstants.regular(
                              context,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// 👉 CHEVRON (ULTRA STYLE)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          CommonText(
            "No notifications yet",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
