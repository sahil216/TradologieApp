class WebviewParams {
  final String url;
  final bool? canPop;
  final bool isAppBar;
  final bool isShowDrawer;
  final bool isShowNotification;
  final String? title;

  /// Called when the loaded URL changes (navigation / redirect / form submit).
  final void Function(String url)? onUrlChanged;

  WebviewParams({
    required this.url,
    this.canPop,
    required this.isAppBar,
    this.isShowDrawer = false,
    this.isShowNotification = false,
    this.title,
    this.onUrlChanged,
  });
}
