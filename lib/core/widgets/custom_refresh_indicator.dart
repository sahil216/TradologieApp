import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final void Function() onRefresh;
  final RefreshController refreshController;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    required this.refreshController,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: const MaterialClassicHeader(),
        controller: refreshController,
        onRefresh: onRefresh,
        child: child,
      ),
    );
  }
}
