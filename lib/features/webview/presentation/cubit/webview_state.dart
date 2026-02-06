part of 'webview_cubit.dart';

abstract class WebViewState {}

class WebViewInitial extends WebViewState {}

class WebPageLoading extends WebViewState {}

class WebPageLoaded extends WebViewState {
  final String url;
  WebPageLoaded(this.url);
}

class SpecialPageDetected extends WebViewState {
  final String url;
  SpecialPageDetected(this.url);
}
