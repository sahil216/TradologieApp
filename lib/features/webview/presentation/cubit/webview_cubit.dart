import 'package:flutter_bloc/flutter_bloc.dart';

part 'webview_state.dart';

class WebViewCubit extends Cubit<WebViewState> {
  WebViewCubit() : super(WebPageLoading());

  /// Call on page start
  void onPageStarted(String url) {
    emit(WebPageLoading());
  }

  /// Call on page finish
  void onPageFinished(String url) {
    if (url.contains("Default")) {
      emit(SpecialPageDetected(url));
    } else {
      emit(WebPageLoaded(url));
    }
  }
}
