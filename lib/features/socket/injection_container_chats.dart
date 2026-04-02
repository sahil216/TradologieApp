import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/socket/data/signalr_service.dart';
import 'package:tradologie_app/features/socket/presentation/chat_bloc.dart';
import 'package:tradologie_app/features/socket/presentation/cubit/attachement_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Service
  sl.registerLazySingleton<SignalRService>(
    () => SignalRService(),
  );

  sl.registerFactory<ChatBloc>(
    () => ChatBloc(sl()),
  );

  sl.registerFactory<AttachmentCubit>(
    () => AttachmentCubit(),
  );
}
