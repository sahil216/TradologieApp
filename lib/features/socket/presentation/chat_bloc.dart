import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';
import 'package:tradologie_app/features/socket/data/signalr_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SignalRService _service;
  AudioRecorder? _recorder;

  StreamSubscription? _msgSub;
  StreamSubscription? _connSub;
  StreamSubscription? _typingSub;
  Timer? _typingTimer;
  Timer? _recordingTimer;
  Duration _recordingDuration = Duration.zero;
  String? _recordingPath;

  ChatBloc(this._service) : super(const ChatInitial()) {
    on<ChatConnectEvent>(_onConnect);
    on<ChatDisconnectEvent>(_onDisconnect);
    on<ChatSendMessageEvent>(_onSendMessage);
    on<ChatSendImageEvent>(_onSendImage);
    on<ChatSendPdfEvent>(_onSendPdf);
    on<ChatSendVoiceEvent>(_onSendVoice);
    on<ChatMessageReceivedEvent>(_onMessageReceived);
    on<ChatConnectionChangedEvent>(_onConnectionChanged);
    on<ChatTypingEvent>(_onTyping);
    on<ChatUserTypingEvent>(_onUserTyping);
    on<ChatStartRecordingEvent>(_onStartRecording);
    on<ChatStopRecordingEvent>(_onStopRecording);
    on<ChatCancelRecordingEvent>(_onCancelRecording);
    on<ChatRecordingTickEvent>(_onRecordingTick);
    on<ChatUpdateMessageEvent>(_onUpdateMessage);
  }

  Future<void> _onConnect(
      ChatConnectEvent event, Emitter<ChatState> emit) async {
    emit(const ChatConnecting());
    try {
      await _service.connect(event.userId);

      _msgSub = _service.messageStream.listen((msg) {
        add(ChatMessageReceivedEvent(msg));
      });

      _connSub = _service.connectionStream.listen((connected) {
        add(ChatConnectionChangedEvent(connected));
      });

      _typingSub = _service.typingStream.listen((userId) {
        add(ChatUserTypingEvent(userId));
      });

      emit(const ChatConnected());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onDisconnect(
      ChatDisconnectEvent event, Emitter<ChatState> emit) async {
    await _service.disconnect();
    emit(const ChatDisconnected());
  }

  Future<void> _onSendMessage(
      ChatSendMessageEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    final optimistic = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromUserId: "me",
      message: event.message,
      type: MessageType.text,
      status: MessageStatus.sending,
      timestamp: DateTime.now(),
    );

    emit(current.copyWith(messages: [...current.messages, optimistic]));

    try {
      await _service.sendMessage(event.toUser, event.message);
      final updated = optimistic.copyWith(status: MessageStatus.sent);
      final updatedMessages = current.messages.map((m) {
        return m.id == optimistic.id ? updated : m;
      }).toList()
        ..add(updated);

      emit(current.copyWith(
        messages: current.messages
            .map((m) => m.id == optimistic.id
                ? optimistic.copyWith(status: MessageStatus.sent)
                : m)
            .toList(),
      ));
    } catch (e) {
      emit(current.copyWith(
        messages: current.messages
            .map((m) => m.id == optimistic.id
                ? optimistic.copyWith(status: MessageStatus.failed)
                : m)
            .toList(),
      ));
    }
  }

  Future<void> _onSendImage(
      ChatSendImageEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final optimistic = ChatMessageModel(
      id: tempId,
      fromUserId: "me",
      message: "Photo",
      type: MessageType.image,
      localFilePath: event.file.path,
      fileName: event.file.path.split('/').last,
      fileSize: await event.file.length(),
      status: MessageStatus.sending,
      timestamp: DateTime.now(),
      isUploading: true,
    );

    emit(current.copyWith(messages: [...current.messages, optimistic]));

    try {
      await _service.sendFile(
        toUser: event.toUser,
        file: event.file,
        fileType: 'image',
        fileName: optimistic.fileName,
      );
      emit((state as ChatConnected).copyWith(
        messages: (state as ChatConnected)
            .messages
            .map((m) => m.id == tempId
                ? m.copyWith(status: MessageStatus.sent, isUploading: false)
                : m)
            .toList(),
      ));
    } catch (e) {
      emit((state as ChatConnected).copyWith(
        messages: (state as ChatConnected)
            .messages
            .map((m) => m.id == tempId
                ? m.copyWith(status: MessageStatus.failed, isUploading: false)
                : m)
            .toList(),
      ));
    }
  }

  Future<void> _onSendPdf(
      ChatSendPdfEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final fileName = event.file.path.split('/').last;
    final fileSize = await event.file.length();

    final optimistic = ChatMessageModel(
      id: tempId,
      fromUserId: "me",
      message: fileName,
      type: MessageType.pdf,
      localFilePath: event.file.path,
      fileName: fileName,
      fileSize: fileSize,
      status: MessageStatus.sending,
      timestamp: DateTime.now(),
      isUploading: true,
    );

    emit(current.copyWith(messages: [...current.messages, optimistic]));

    try {
      await _service.sendFile(
        toUser: event.toUser,
        file: event.file,
        fileType: 'pdf',
        fileName: fileName,
      );
      emit((state as ChatConnected).copyWith(
        messages: (state as ChatConnected)
            .messages
            .map((m) => m.id == tempId
                ? m.copyWith(status: MessageStatus.sent, isUploading: false)
                : m)
            .toList(),
      ));
    } catch (e) {
      emit((state as ChatConnected).copyWith(
        messages: (state as ChatConnected)
            .messages
            .map((m) => m.id == tempId
                ? m.copyWith(status: MessageStatus.failed, isUploading: false)
                : m)
            .toList(),
      ));
    }
  }

  Future<void> _onSendVoice(
      ChatSendVoiceEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final optimistic = ChatMessageModel(
      id: tempId,
      fromUserId: "me",
      message: "Voice message",
      type: MessageType.voice,
      localFilePath: event.file.path,
      duration: event.duration,
      status: MessageStatus.sending,
      timestamp: DateTime.now(),
      isUploading: true,
    );

    emit(current.copyWith(messages: [...current.messages, optimistic]));

    try {
      await _service.sendFile(
        toUser: event.toUser,
        file: event.file,
        fileType: 'audio',
        duration: event.duration.inSeconds,
      );
      emit((state as ChatConnected).copyWith(
        messages: (state as ChatConnected)
            .messages
            .map((m) => m.id == tempId
                ? m.copyWith(status: MessageStatus.sent, isUploading: false)
                : m)
            .toList(),
      ));
    } catch (e) {
      emit((state as ChatConnected).copyWith(
        messages: (state as ChatConnected)
            .messages
            .map((m) => m.id == tempId
                ? m.copyWith(status: MessageStatus.failed, isUploading: false)
                : m)
            .toList(),
      ));
    }
  }

  void _onMessageReceived(
      ChatMessageReceivedEvent event, Emitter<ChatState> emit) {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;
    emit(current.copyWith(messages: [...current.messages, event.message]));
  }

  void _onConnectionChanged(
      ChatConnectionChangedEvent event, Emitter<ChatState> emit) {
    if (!event.isConnected) {
      if (state is ChatConnected) {
        emit(const ChatDisconnected(reason: "Connection lost"));
      }
    } else {
      if (state is! ChatConnected) {
        emit(const ChatConnected());
      }
    }
  }

  void _onTyping(ChatTypingEvent event, Emitter<ChatState> emit) {
    _typingTimer?.cancel();
    _service.sendTyping(event.toUser);
    _typingTimer = Timer(const Duration(seconds: 2), () {});
  }

  void _onUserTyping(ChatUserTypingEvent event, Emitter<ChatState> emit) {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;
    emit(current.copyWith(isTyping: true, typingUserId: event.userId));
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), () {
      if (state is ChatConnected) {
        emit((state as ChatConnected)
            .copyWith(isTyping: false, typingUserId: ''));
      }
    });
  }

  Future<void> _onStartRecording(
      ChatStartRecordingEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    try {
      _recorder ??=
          AudioRecorder(); // created lazily — avoids MissingPluginException at startup
      final hasPermission = await _recorder!.hasPermission();
      if (!hasPermission) return;

      final dir = await getTemporaryDirectory();
      _recordingPath =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _recordingDuration = Duration.zero;

      await _recorder!.start(
        RecordConfig(
            encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
        path: _recordingPath!,
      );

      emit(current.copyWith(
          isRecording: true, recordingDuration: Duration.zero));

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _recordingDuration += const Duration(seconds: 1);
        add(ChatRecordingTickEvent(_recordingDuration));
      });
    } catch (e) {
      emit(ChatError('Microphone permission denied'));
    }
  }

  Future<void> _onStopRecording(
      ChatStopRecordingEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    _recordingTimer?.cancel();
    final path = await _recorder?.stop();

    emit(
        current.copyWith(isRecording: false, recordingDuration: Duration.zero));

    if (path != null && _recordingDuration.inSeconds >= 1) {
      add(ChatSendVoiceEvent(
        toUser: event.toUser,
        file: File(path),
        duration: _recordingDuration,
      ));
    }
    _recordingDuration = Duration.zero;
  }

  Future<void> _onCancelRecording(
      ChatCancelRecordingEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    _recordingTimer?.cancel();
    await _recorder?.stop();
    _recordingDuration = Duration.zero;

    if (_recordingPath != null) {
      final file = File(_recordingPath!);
      if (await file.exists()) await file.delete();
    }

    emit(
        current.copyWith(isRecording: false, recordingDuration: Duration.zero));
  }

  void _onRecordingTick(ChatRecordingTickEvent event, Emitter<ChatState> emit) {
    if (state is! ChatConnected) return;
    emit((state as ChatConnected).copyWith(recordingDuration: event.duration));
  }

  void _onUpdateMessage(ChatUpdateMessageEvent event, Emitter<ChatState> emit) {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;
    emit(current.copyWith(
      messages: current.messages
          .map((m) => m.id == event.message.id ? event.message : m)
          .toList(),
    ));
  }

  @override
  Future<void> close() {
    _msgSub?.cancel();
    _connSub?.cancel();
    _typingSub?.cancel();
    _typingTimer?.cancel();
    _recordingTimer?.cancel();
    _recorder?.dispose();
    _service.dispose();
    return super.close();
  }
}
