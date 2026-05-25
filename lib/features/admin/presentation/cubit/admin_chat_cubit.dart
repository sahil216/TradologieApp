import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/features/admin/data/admin_signalr_service.dart';
import 'package:tradologie_app/features/admin/data/models/admin_connect_send_message.dart';
import 'package:tradologie_app/features/admin/data/models/admin_message_info.dart';
import 'package:tradologie_app/features/admin/domain/usecases/get_admin_chat_history_usecase.dart';
import 'package:tradologie_app/features/admin/presentation/cubit/admin_chat_event.dart';
import 'package:tradologie_app/features/admin/presentation/cubit/admin_chat_state.dart';
import 'package:tradologie_app/features/admin/presentation/viewmodel/admin_connect_chat_config.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';

class AdminChatCubit extends Bloc<AdminChatEvent, AdminChatState> {
  final AdminSignalRService _service;
  final GetAdminChatHistoryUsecase _getChatHistoryUsecase;

  String _fromUserId = '';
  String _toUserId = '';
  String _apiCode = '';
  String _type1 = '';
  String _type2 = '';
  bool _isConnectChat = false;

  StreamSubscription<ChatMessage>? _msgSub;
  StreamSubscription<bool>? _connSub;

  int _connectSession = 0;
  bool _lifecyclePaused = false;
  bool _hasConnectedOnce = false;

  AdminChatCubit(this._service, this._getChatHistoryUsecase)
      : super(const AdminChatInitial()) {
    on<AdminChatConnect>(_onConnect);
    on<AdminChatDisconnect>(_onDisconnect);
    on<AdminChatPause>(_onPause);
    on<AdminChatResume>(_onResume);
    on<AdminChatSendText>(_onSendText);
    on<AdminChatMessageReceived>(_onMessageReceived);
    on<AdminChatConnectionChanged>(_onConnectionChanged);
  }

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[AdminChatCubit] $message');
    }
  }

  List<ChatMessage> _currentMessages() {
    final s = state;
    if (s is AdminChatConnected) return s.messages;
    if (s is AdminChatConnecting) return s.messages;
    if (s is AdminChatDisconnected) return s.messages;
    return const [];
  }

  Future<void> _cancelSubscriptions() async {
    await _msgSub?.cancel();
    await _connSub?.cancel();
    _msgSub = null;
    _connSub = null;
  }

  void _attachStreamListeners() {
    _msgSub = _service.messageStream.listen((msg) {
      add(AdminChatMessageReceived(msg));
    });
    _connSub = _service.connectionStream.listen((connected) {
      add(AdminChatConnectionChanged(connected));
    });
  }

  String get _activeChatOtherUserId => _isConnectChat
      ? AdminConnectChatConfig.toUserId
      : _toUserId;

  Future<bool> _connectSignalR(int session) async {
    final signalSw = Stopwatch()..start();
    final connected = await _service.connect(
      _fromUserId,
      apiCode: _apiCode,
      isVendorSide: _isConnectChat,
      otherUserId: _activeChatOtherUserId,
    );
    if (session != _connectSession || !connected) {
      return false;
    }
    _log('SignalR connect took ${signalSw.elapsedMilliseconds}ms');
    _attachStreamListeners();
    return true;
  }

  bool _canEmit(Emitter<AdminChatState> emit) => !isClosed;

  void _emitConnectFailed(
    Emitter<AdminChatState> emit, {
    required List<ChatMessage> messages,
    String reason = 'Could not connect to chat. Please try again.',
  }) {
    if (!_canEmit(emit) || _lifecyclePaused) return;
    if (state is AdminChatConnecting || state is AdminChatInitial) {
      emit(AdminChatDisconnected(reason: reason, messages: messages));
    }
  }

  Future<void> _onConnect(
    AdminChatConnect event,
    Emitter<AdminChatState> emit,
  ) async {
    final session = ++_connectSession;
    _lifecyclePaused = false;
    _hasConnectedOnce = false;

    await _cancelSubscriptions();
    if (!_canEmit(emit) || session != _connectSession) return;

    _fromUserId = event.fromUserId;
    _toUserId = event.toUserId;
    _apiCode = event.apiCode;
    _type1 = event.type1;
    _type2 = event.type2;
    _isConnectChat = event.isConnectChat;

    if (!_canEmit(emit)) return;

    emit(const AdminChatConnecting());

    var history = <ChatMessage>[];
    try {
      if (session != _connectSession) return;

      final totalSw = Stopwatch()..start();

      // Run in parallel — do not block SignalR on slow history API.
      final historyFuture = _loadChatHistory().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          _log('chat history timed out — continuing without history');
          return <ChatMessage>[];
        },
      );
      final connectFuture = _connectSignalR(session);

      final results = await Future.wait([
        connectFuture,
        historyFuture,
      ]);
      final connected = results[0] as bool;
      history = results[1] as List<ChatMessage>;

      _log('chat history count=${history.length}');
      if (!_canEmit(emit) || session != _connectSession) {
        _emitConnectFailed(emit, messages: history);
        return;
      }

      if (history.isNotEmpty && state is AdminChatConnecting) {
        emit(AdminChatConnecting(messages: history));
      }

      if (!connected) {
        _emitConnectFailed(emit, messages: history);
        return;
      }

      _hasConnectedOnce = true;
      _log('first connect TOTAL ${totalSw.elapsedMilliseconds}ms');
      emit(AdminChatConnected(messages: history));
    } catch (e) {
      if (!_canEmit(emit) || session != _connectSession) {
        _emitConnectFailed(emit, messages: history);
        return;
      }
      emit(AdminChatDisconnected(
        reason: _friendlyError(e),
        messages: history,
      ));
    }
  }

  Future<void> _onPause(
    AdminChatPause event,
    Emitter<AdminChatState> emit,
  ) async {
    if (_lifecyclePaused) return;
    _lifecyclePaused = true;

    final messages = _currentMessages();
    _log('pause — disconnecting hub (${messages.length} messages kept)');

    await _cancelSubscriptions();
    await _service.pauseConnection();

    // Keep showing messages without the reconnect spinner overlay.
    if (!_canEmit(emit)) return;
    if (messages.isNotEmpty) {
      emit(AdminChatConnected(messages: messages));
    } else {
      emit(const AdminChatConnecting());
    }
  }

  Future<void> _onResume(
    AdminChatResume event,
    Emitter<AdminChatState> emit,
  ) async {
    if (!_lifecyclePaused || _fromUserId.isEmpty) return;
    _lifecyclePaused = false;

    final session = ++_connectSession;
    final messages = _currentMessages();

    _log('resume — reconnecting hub (${messages.length} messages)');

    emit(AdminChatConnecting(messages: messages));

    try {
      await _cancelSubscriptions();
      if (session != _connectSession) return;

      final resumeSw = Stopwatch()..start();
      final connected = await _connectSignalR(session);
      if (session != _connectSession) return;

      if (!connected) {
        _emitConnectFailed(emit, messages: messages);
        return;
      }

      _log('resume reconnect took ${resumeSw.elapsedMilliseconds}ms');
      emit(AdminChatConnected(messages: messages));
    } catch (e) {
      if (session != _connectSession) return;
      emit(AdminChatDisconnected(
        reason: _friendlyError(e),
        messages: messages,
      ));
    }
  }

  Future<List<ChatMessage>> _loadChatHistory() async {
    final historyToUserId = _isConnectChat
        ? AdminConnectChatConfig.historyToUserId
        : int.tryParse(_toUserId) ?? 0;

    final result = await _getChatHistoryUsecase(
      GetAdminChatHistoryParams(
        apiCode: _apiCode,
        fromUserId: _fromUserId,
        toUserId: historyToUserId,
        type1: _type1,
        type2: _type2,
        isVendorSide: _isConnectChat,
      ),
    );

    return result.fold((_) => <ChatMessage>[], (messages) => messages);
  }

  Future<void> _onDisconnect(
    AdminChatDisconnect event,
    Emitter<AdminChatState> emit,
  ) async {
    _connectSession++;
    _lifecyclePaused = false;
    _hasConnectedOnce = false;
    await _cancelSubscriptions();
    await _service.clearActiveChat();
    await _service.disconnect();
    if (!_canEmit(emit)) return;
    emit(const AdminChatDisconnected());
  }

  Future<void> _onSendText(
    AdminChatSendText event,
    Emitter<AdminChatState> emit,
  ) async {
    if (state is! AdminChatConnected) return;
    final current = state as AdminChatConnected;

    final text = event.text.trim();
    if (text.isEmpty) return;

    final optimistic = ChatMessage(
      user: _fromUserId,
      message: text,
      type: 'text',
      isMe: true,
      isUploading: true,
    );

    emit(current.copyWith(
      messages: [...current.messages, optimistic],
      isSending: true,
    ));

    try {
      if (_isConnectChat) {
        await _service.sendConnectMessage(
          AdminConnectSendMessage(
            fromUserId: _fromUserId,
            apiCode: _apiCode,
            messageInfo: AdminMessageInfo(message: text),
          ),
        );
      } else {
        await _service.sendAgroAdminMessage(
          fromUserId: _fromUserId,
          toUserId: _toUserId,
          apiCode: _apiCode,
          type1: _type1,
          type2: _type2,
          messageInfo: AdminMessageInfo(message: text),
        );
      }

      final latest = state is AdminChatConnected
          ? state as AdminChatConnected
          : current;
      final updated = latest.messages
          .map(
            (m) => identical(m, optimistic)
                ? optimistic.copyWith(isUploading: false)
                : m,
          )
          .toList();
      emit(latest.copyWith(messages: updated, isSending: false));
    } catch (e) {
      emit(AdminChatError(e.toString()));
      emit(current.copyWith(isSending: false));
    }
  }

  void _onMessageReceived(
    AdminChatMessageReceived event,
    Emitter<AdminChatState> emit,
  ) {
    if (state is! AdminChatConnected) return;
    final current = state as AdminChatConnected;

    final incoming = event.message;

    if (incoming.isMe) {
      final alreadySent = current.messages.any(
        (m) => m.isMe && !m.isUploading && m.message == incoming.message,
      );
      if (alreadySent) return;
    }

    final exists = current.messages.any(
      (m) => _isDuplicateMessage(m, incoming),
    );
    if (exists) return;

    emit(current.copyWith(messages: [...current.messages, incoming]));
  }

  bool _isDuplicateMessage(ChatMessage existing, ChatMessage incoming) {
    if (existing.message != incoming.message) return false;
    if (existing.isMe != incoming.isMe) return false;
    if (existing.timestamp != null &&
        incoming.timestamp != null &&
        existing.timestamp == incoming.timestamp) {
      return true;
    }
    return existing.user == incoming.user &&
        existing.user != null &&
        existing.user!.isNotEmpty;
  }

  void _onConnectionChanged(
    AdminChatConnectionChanged event,
    Emitter<AdminChatState> emit,
  ) {
    if (_lifecyclePaused) return;

    if (!event.connected && state is AdminChatConnected) {
      final current = state as AdminChatConnected;
      emit(AdminChatDisconnected(
        reason: 'Connection lost',
        messages: current.messages,
      ));
    }
  }

  String _friendlyError(Object e) {
    print("Gopal $e");
    final raw = e.toString();
    if (raw.contains('StateError') ||
        raw.contains('Null check operator') ||
        raw.contains('handshake')) {
      return 'Could not connect to chat. Please try again.';
    }
    if (raw.length > 120) return '${raw.substring(0, 120)}…';
    return raw;
  }

  @override
  Future<void> close() async {
    _connectSession++;
    _lifecyclePaused = false;
    await _cancelSubscriptions();
    await _service.clearActiveChat();
    await _service.disconnect();
    return super.close();
  }
}
