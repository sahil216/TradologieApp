import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/socket/data/signalr_service.dart';
import 'package:tradologie_app/features/socket/presentation/chat_view_model.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! ---------------- CHAT ----------------

  // Service
  sl.registerLazySingleton<SignalRService>(
    () => SignalRService(),
  );

  // Cubit
  sl.registerFactory<ChatsCubit>(
    () => ChatsCubit(sl()),
  );
}
