import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
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

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationDetail>? data;

  NotificationCubit get cubit => BlocProvider.of<NotificationCubit>(context);

  Future<void> getInformation() async {
    await cubit.getNotification(NoParams());
  }

  @override
  void initState() {
    super.initState();
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
              data = state.data;
            }
            if (state is NotificationError) {
              Constants.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: AdaptiveScaffold(
        appBar:
            Constants.appBar(context, title: 'Notification', centerTitle: true),
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
            return SafeArea(
              child: data!.isEmpty
                  ? _emptyState()
                  : ListView.separated(
                      padding: EdgeInsets.all(16),
                      itemCount: data?.length ?? 0,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        return _notificationTile(data![index]);
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _notificationTile(NotificationDetail notification) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    notification.contentTitle ?? "",
                    style: TextStyleConstants.semiBold(context, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  CommonText(
                    notification.contentText ?? "",
                    style: TextStyleConstants.medium(context, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  CommonText(
                    Constants.dateFormat(DateTime.parse(
                        notification.updatedDate ??
                            "")), // DateTime.parse(notification.updatedDate)
                    style: TextStyleConstants.regular(context, fontSize: 13),
                  ),
                ],
              ),
            ),
            // if (!notification.isRead)
            //   Container(
            //     width: 8,
            //     height: 8,
            //     decoration: const BoxDecoration(
            //       color: Colors.blue,
            //       shape: BoxShape.circle,
            //     ),
            //   ),
          ],
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
