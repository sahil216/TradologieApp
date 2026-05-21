import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:tradologie_app/core/utils/notification_badge_service.dart';
import 'package:tradologie_app/injection_container.dart';

import '../../../../core/error/network_failure.dart';
import '../../../../core/error/user_failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    sl<NotificationBadgeService>().clear();
    getInformation();
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

              /// Unread first, then latest date.
              data!.sort((a, b) {
                if (a.isUnread != b.isUnread) {
                  return a.isUnread ? -1 : 1;
                }
                final dateA =
                    DateTime.tryParse(a.updatedDate ?? '') ?? DateTime(1970);
                final dateB =
                    DateTime.tryParse(b.updatedDate ?? '') ?? DateTime(1970);
                return dateB.compareTo(dateA);
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
            return CustomScrollView(
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
            );
          },
        ),
      ),
    );
  }

  Widget _notificationTile(NotificationDetail notification) {
    final isUnread = notification.isUnread;
    final titleColor =
        isUnread ? AppColors.defaultText : AppColors.grayText;
    final bodyColor =
        isUnread ? AppColors.blackApp : AppColors.grayText;

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isUnread
                  ? AppColors.blueExtraLight
                  : Colors.white.withValues(alpha: 0.9),
              border: Border.all(
                color: isUnread
                    ? AppColors.primary.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.06),
                width: isUnread ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: isUnread ? 12 : 6,
                  offset: const Offset(0, 4),
                  color: isUnread
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.04),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(16),
                      ),
                      color: isUnread
                          ? AppColors.orange
                          : Colors.transparent,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isUnread
                                  ? AppColors.primary.withValues(alpha: 0.12)
                                  : AppColors.defaultBaseShimmer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isUnread
                                  ? Icons.notifications_active_outlined
                                  : Icons.notifications_none_outlined,
                              size: 22,
                              color: isUnread
                                  ? AppColors.primary
                                  : AppColors.grayText,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CommonText(
                                        notification.contentTitle ?? '',
                                        style: isUnread
                                            ? TextStyleConstants.semiBold(
                                                context,
                                                fontSize: 16,
                                                color: titleColor,
                                              )
                                            : TextStyleConstants.medium(
                                                context,
                                                fontSize: 16,
                                                color: titleColor,
                                              ),
                                      ),
                                    ),
                                    if (isUnread) _unreadChip(),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                CommonText(
                                  notification.contentText ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyleConstants.regular(
                                    context,
                                    fontSize: 14,
                                    color: bodyColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 14,
                                      color: isUnread
                                          ? AppColors.primary
                                          : AppColors.grayText,
                                    ),
                                    const SizedBox(width: 6),
                                    CommonText(
                                      _formatDate(notification.updatedDate),
                                      style: TextStyleConstants.regular(
                                        context,
                                        fontSize: 12,
                                        color: isUnread
                                            ? AppColors.blueDark
                                            : AppColors.grayText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(top: 6),
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _unreadChip() {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Unread',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.orange,
        ),
      ),
    );
  }

  String _formatDate(String? raw) {
    final parsed = DateTime.tryParse(raw ?? '');
    if (parsed == null) return raw ?? '';
    return Constants.dateFormat(parsed);
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
