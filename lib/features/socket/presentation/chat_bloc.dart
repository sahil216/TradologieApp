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
  AudioRecorder? _recorder; // lazy — avoids MissingPluginException at startup

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
    // on<ChatTypingEvent>(_onTyping);
    on<ChatUserTypingEvent>(_onUserTyping);
    on<ChatStartRecordingEvent>(_onStartRecording);
    on<ChatStopRecordingEvent>(_onStopRecording);
    on<ChatCancelRecordingEvent>(_onCancelRecording);
    on<ChatRecordingTickEvent>(_onRecordingTick);
    on<ChatUpdateMessageEvent>(_onUpdateMessage);
  }

  // ─────────────── Connect ───────────────
  Future<void> _onConnect(
      ChatConnectEvent event, Emitter<ChatState> emit) async {
    emit(const ChatConnecting());
    try {
      await _service.connect(event.userId, role: event.role);

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

  // ─────────────── Send Text ───────────────
  Future<void> _onSendMessage(
      ChatSendMessageEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    final optimistic = ChatMessage(
      user: "1",
      message: event.message,
      type: "text",
      isMe: true,
      isUploading: false,
    );

    emit(current.copyWith(messages: [...current.messages, optimistic]));

    try {
      // Pass the full ChatMessage model — service calls .toJson() before invoking hub
      await _service.sendMessage(event.toUser, optimistic);
    } catch (_) {
      // message stays in list; isUploading can surface failure if needed
    }
  }

  // ─────────────── Send Image ───────────────
  Future<void> _onSendImage(
      ChatSendImageEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    final optimistic = ChatMessage(
      user: "me",
      message: event.file.path.split('/').last,
      fileType: "image",
      type: "file",
      localFilePath: event.file.path,
      isMe: true,
      isUploading: true,
    );

    emit(current.copyWith(messages: [...current.messages, optimistic]));

    try {
      await _service.sendImage(
        toUser: event.toUser,
        file: event.file,
        mimeType: "image/jpeg",
        fileName: optimistic.message,
      );
      _updateLast(optimistic, isUploading: false);
    } catch (_) {
      _updateLast(optimistic, isUploading: false);
    }
  }

  // ─────────────── Send PDF ───────────────
  Future<void> _onSendPdf(
      ChatSendPdfEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    final fileName = event.file.path.split('/').last;
    final optimistic = ChatMessage(
      user: "me",
      message: fileName,
      fileType: "pdf",
      type: "file",
      localFilePath: event.file.path,
      isMe: true,
      isUploading: true,
    );

    emit(current.copyWith(messages: [...current.messages, optimistic]));

    try {
      await _service.sendPdf(
          toUser: event.toUser, file: event.file, fileName: fileName);
      _updateLast(optimistic, isUploading: false);
    } catch (_) {
      _updateLast(optimistic, isUploading: false);
    }
  }

  // ─────────────── Send Voice ───────────────
  Future<void> _onSendVoice(
      ChatSendVoiceEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    final optimistic = ChatMessage(
      user: "me",
      message: "Voice message",
      fileType: "audio",
      type: "file",
      localFilePath: event.file.path,
      duration: event.duration,
      isMe: true,
      isUploading: true,
    );

    emit(current.copyWith(messages: [...current.messages, optimistic]));

    try {
      await _service.sendVoice(
        toUser: event.toUser,
        file: event.file,
        duration: event.duration,
      );
      _updateLast(optimistic, isUploading: false);
    } catch (_) {
      _updateLast(optimistic, isUploading: false);
    }
  }

  // ─────────────── Receive ───────────────
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
      if (state is! ChatConnected) emit(const ChatConnected());
    }
  }

  // // ─────────────── Typing ───────────────
  // void _onTyping(ChatTypingEvent event, Emitter<ChatState> emit) {
  //   _service.sendTyping(event.toUser);
  // }

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

  // ─────────────── Recording ───────────────
  Future<void> _onStartRecording(
      ChatStartRecordingEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    try {
      _recorder ??= AudioRecorder();
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
      emit(ChatError('Microphone error: $e'));
    }
  }

  Future<void> _onStopRecording(
      ChatStopRecordingEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;

    _recordingTimer?.cancel();
    final path = await _recorder?.stop();
    final capturedDuration = _recordingDuration;
    _recordingDuration = Duration.zero;

    emit(
        current.copyWith(isRecording: false, recordingDuration: Duration.zero));

    if (path != null && capturedDuration.inSeconds >= 1) {
      add(ChatSendVoiceEvent(
        toUser: event.toUser,
        file: File(path),
        duration: capturedDuration,
      ));
    }
  }

  Future<void> _onCancelRecording(
      ChatCancelRecordingEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatConnected) return;
    _recordingTimer?.cancel();
    await _recorder?.stop();
    _recordingDuration = Duration.zero;

    if (_recordingPath != null) {
      final f = File(_recordingPath!);
      if (await f.exists()) await f.delete();
    }

    emit((state as ChatConnected)
        .copyWith(isRecording: false, recordingDuration: Duration.zero));
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
          .map((m) => m == event.message ? event.message : m)
          .toList(),
    ));
  }

  // ─────────────── Helper ───────────────
  /// Update the last message matching [original] in the current state.
  void _updateLast(ChatMessage original, {required bool isUploading}) {
    if (state is! ChatConnected) return;
    final current = state as ChatConnected;
    final updated = current.messages.map((m) {
      return m == original ? m.copyWith(isUploading: isUploading) : m;
    }).toList();
    emit(current.copyWith(messages: updated));
  }

  @override
  Future<void> close() async {
    _msgSub?.cancel();
    _connSub?.cancel();
    _typingSub?.cancel();
    _typingTimer?.cancel();
    _recordingTimer?.cancel();
    _recorder?.dispose();
    await _service.dispose();
    return super.close();
  }
}
