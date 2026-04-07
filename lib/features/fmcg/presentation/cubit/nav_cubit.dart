// navigation_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0); // default tab index

  void setTab(int index) => emit(index);

  void goToChat() => emit(1); // Chats tab
}
