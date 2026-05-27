import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:tradologie_app/features/admin/data/models/admin_connect_send_message.dart';
import 'package:tradologie_app/features/admin/data/models/admin_message_info.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';

/// Connect chat hub on connect.tradologie.com (negotiated transport).
class AdminSignalRService {
  static final Logger _signalrPackageLogger = Logger('AdminSignalR');
  static bool _signalrPackageLoggerHooked = false;

  HubConnection? hub;

  /// Hub built and starting; not promoted to [hub] until start + invoke succeed.
  HubConnection? _pendingHub;

  final String baseUrl = 'https://connect.tradologie.com';

  String myUserId = '';
  String senderRole = '';
  String _apiCode = '';
  bool _isVendorSide = false;
  String _activeOtherUserId = '';

  StreamController<ChatMessage> _messageController =
      StreamController<ChatMessage>.broadcast();
  StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  StreamController<String> _typingController =
      StreamController<String>.broadcast();

  Stream<ChatMessage> get messageStream => _messageController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<String> get typingStream => _typingController.stream;

  bool get isConnected => hub?.state == HubConnectionState.Connected;

  bool get hasActiveHubs =>
      hub != null || _pendingHub != null || _trackedHubs.isNotEmpty;

  bool _intentionalDisconnect = false;

  /// Invalidates in-flight [connect]; incremented on pause/disconnect/dispose.
  int _operationGen = 0;

  static int _connectAttempt = 0;

  static const int _maxStartAttempts = 2;

  static const Duration _hubStopTimeout = Duration(milliseconds: 800);

  static const Duration _hubStartTimeout = Duration(seconds: 25);

  static const Duration _waitDisconnectedTimeout =
      Duration(milliseconds: 500);

  /// Invalidates only when a newer [connect] is requested (not on stop/pause).
  int _connectEpoch = 0;

  /// Every hub instance created for this app session (stops all on chat open).
  final Set<HubConnection> _trackedHubs = {};

  /// Serializes connect / pause / disconnect.
  Future<void> _serial = Future.value();

  Future<T> _enqueue<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _serial = _serial.then((_) async {
      try {
        if (!completer.isCompleted) {
          completer.complete(await action());
        }
      } catch (e, st) {
        if (!completer.isCompleted) {
          completer.completeError(e, st);
        }
      }
    });
    return completer.future;
  }

  bool _isConnectCurrent(int epoch) => epoch == _connectEpoch;

  bool _isCurrentOp(int gen) => gen == _operationGen;

  Future<void> _settleAfterStop({int milliseconds = 80}) async {
    await Future<void>.delayed(Duration(milliseconds: milliseconds));
  }

  bool _isRetryableStartError(Object e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('null check operator') ||
        msg.contains('handshake') ||
        msg.contains('connection was stopped') ||
        msg.contains('connection was closed') ||
        msg.contains('not in the \'disconnected\' state') ||
        msg.contains('hub not in disconnected') ||
        msg.contains('timed out');
  }

  /// Poll only — caller should have already invoked [HubConnection.stop].
  Future<void> _waitUntilDisconnected(HubConnection connection) async {
    final deadline = DateTime.now().add(_waitDisconnectedTimeout);
    while (connection.state != HubConnectionState.Disconnected) {
      if (DateTime.now().isAfter(deadline)) {
        _log(
          '_waitUntilDisconnected: gave up in state=${connection.state}',
        );
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }
  }

  Future<void> _startHub(HubConnection connection) async {
    if (connection.state != HubConnectionState.Disconnected) {
      _log('hub.start — unexpected state=${connection.state}, stopping once');
      try {
        await connection.stop().timeout(
          _hubStopTimeout,
          onTimeout: () => _log('hub.start pre-stop timed out'),
        );
      } catch (_) {}
      await _waitUntilDisconnected(connection);
    }
    if (connection.state != HubConnectionState.Disconnected) {
      throw StateError(
        'Hub not in Disconnected state before start (${connection.state})',
      );
    }
    final startFuture = connection.start();
    if (startFuture == null) {
      throw StateError('hub.start() returned null');
    }
    await startFuture.timeout(
      _hubStartTimeout,
      onTimeout: () {
        throw TimeoutException(
          'hub.start timed out after ${_hubStartTimeout.inSeconds}s',
        );
      },
    );
  }

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[AdminSignalR] $message');
    }
  }

  void _hookSignalrPackageLogger() {
    if (_signalrPackageLoggerHooked) return;
    _signalrPackageLoggerHooked = true;
    _signalrPackageLogger.onRecord.listen((record) {
      if (kDebugMode) {
        debugPrint('[SIGNALR] ${record.level.name} -> ${record.message}');
      }
    });
  }

  /// Long Polling is reliable on connect.tradologie.com (WS often fails on device).
  HttpConnectionOptions _hubConnectionOptions() {
    _hookSignalrPackageLogger();
    return HttpConnectionOptions(
      transport: HttpTransportType.WebSockets,
      skipNegotiation: false,
      accessTokenFactory: () async => _apiCode,
      requestTimeout: 15000,
      logger: _signalrPackageLogger,
    );
  }


  void _trackHub(HubConnection connection) {
    _trackedHubs.add(connection);
  }

  void _untrackHub(HubConnection connection) {
    _trackedHubs.remove(connection);
  }

  void _setPendingHub(HubConnection connection) {
    _pendingHub = connection;
    _trackHub(connection);
  }

  void _promotePendingToActive(HubConnection connection) {
    _pendingHub = null;
    hub = connection;
    _trackHub(connection);
  }

  void _clearHubRefs(HubConnection connection) {
    _untrackHub(connection);
    if (identical(hub, connection)) hub = null;
    if (identical(_pendingHub, connection)) _pendingHub = null;
  }

  /// Captures hubs to stop without losing references before the queue runs.
  Set<HubConnection> _snapshotHubsForStop() {
    final toStop = Set<HubConnection>.from(_trackedHubs);
    final current = hub;
    final pending = _pendingHub;
    hub = null;
    _pendingHub = null;
    if (current != null) {
      toStop.add(current);
    }
    if (pending != null) {
      toStop.add(pending);
    }
    _trackedHubs.clear();
    return toStop;
  }

  Future<void> _stopHubSnapshot(Set<HubConnection> toStop) async {
    if (toStop.isEmpty) {
      return;
    }

    _log('stopAllConnections: stopping ${toStop.length} hub(s)');
    await Future.wait(toStop.map(_stopHubAsync));
    await _settleAfterStop(milliseconds: 60);
  }

  /// Stops every tracked hub without invalidating an in-flight [connect] op token.
  Future<void> _stopAllTrackedHubs() async {
    _intentionalDisconnect = true;
    final snapshot = _snapshotHubsForStop();
    await _stopHubSnapshot(snapshot);
  }

  /// Call when leaving chat — stops hubs; does not bump [_connectEpoch].
  Future<void> stopAllConnections() {
    _operationGen++;
    _intentionalDisconnect = true;
    final snapshot = _snapshotHubsForStop();
    return _enqueue(() async {
      await _stopHubSnapshot(snapshot);
      _emitConnection(false);
    });
  }

  Future<void> _stopHubAsync(HubConnection existing) async {
    try {
      final state = existing.state;
      if (state == HubConnectionState.Disconnected) return;

      // Don't block connect on a hub still handshaking — drop tracking only.
      if (state == HubConnectionState.Connecting) {
        _log('_stopHubAsync: abandon hub in Connecting');
        return;
      }

      _log('_stopHubAsync: stopping hub (state=$state)');
      await existing.stop().timeout(
        _hubStopTimeout,
        onTimeout: () => _log('_stopHubAsync: stop() timed out'),
      );
      if (existing.state != HubConnectionState.Disconnected) {
        await _waitUntilDisconnected(existing);
      }
    } catch (e) {
      _log('_stopHubAsync error: $e');
    } finally {
      _clearHubRefs(existing);
    }
  }

  /// Stops [hub] and/or [_pendingHub].
  Future<void> _tearDownHub({HubConnection? target}) async {
    final toStop = <HubConnection>{
      if (target != null) target,
      if (hub != null) hub!,
      if (_pendingHub != null) _pendingHub!,
    };
    hub = null;
    _pendingHub = null;
    if (toStop.isEmpty) return;
    await Future.wait(toStop.map(_stopHubAsync));
    await _settleAfterStop(milliseconds: 60);
  }

  Future<bool> _tryReuseConnectedHub({
    required String userId,
    required String otherUserId,
  }) async {
    final existing = hub;
    if (existing == null ||
        existing.state != HubConnectionState.Connected ||
        myUserId != userId) {
      return false;
    }

    try {
      final sw = Stopwatch()..start();
      await existing.invoke('Connect', args: [userId]);
      await _invokeSetActiveChat(existing, userId, otherUserId);
      _log('connect reused hub in ${sw.elapsedMilliseconds}ms');
      _emitConnection(true);
      return true;
    } catch (e) {
      _log('connect reuse failed: $e — rebuilding hub');
      await _tearDownHub(target: existing);
      return false;
    }
  }

  void _ensureControllersOpen() {
    if (_connectionController.isClosed) {
      _connectionController = StreamController<bool>.broadcast();
    }
    if (_typingController.isClosed) {
      _typingController = StreamController<String>.broadcast();
    }
  }

  void _resetMessageStream() {
    if (!_messageController.isClosed) {
      _messageController.close();
    }
    _messageController = StreamController<ChatMessage>.broadcast();
  }

  void _emitIncomingMessage(ChatMessage msg) {
    if (_messageController.isClosed) {
      _resetMessageStream();
    }
    _messageController.add(msg);
  }

  void _emitConnection(bool connected) {
    if (!_connectionController.isClosed) {
      _connectionController.add(connected);
    }
  }

  /// Returns `false` if another pause/disconnect superseded this connect.
  Future<bool> connect(
    String userId, {
    String role = '',
    String apiCode = '',
    bool isVendorSide = false,
    String otherUserId = '',
  }) {
    final epoch = ++_connectEpoch;
    return _enqueue(() async {
      if (!_isConnectCurrent(epoch)) {
        _log('connect skipped — superseded by newer connect request');
        return false;
      }

      _intentionalDisconnect = false;
      return _connectInternal(
        connectEpoch: epoch,
        opGen: _operationGen,
        userId: userId,
        role: role,
        apiCode: apiCode,
        isVendorSide: isVendorSide,
        otherUserId: otherUserId,
      );
    });
  }

  Future<bool> _connectInternal({
    required int connectEpoch,
    required int opGen,
    required String userId,
    String role = '',
    String apiCode = '',
    bool isVendorSide = false,
    String otherUserId = '',
  }) async {
    final attempt = ++_connectAttempt;
    final totalSw = Stopwatch()..start();

    _ensureControllersOpen();

    myUserId = userId;
    senderRole = role;
    _apiCode = apiCode;
    _isVendorSide = isVendorSide;
    _activeOtherUserId = otherUserId.trim();

    if (_apiCode.trim().isEmpty) {
      _log('connect #$attempt aborted — empty apiCode/token');
      return false;
    }

    _log(
      'connect #$attempt START userId=$userId vendorSide=$isVendorSide',
    );

    final stopSw = Stopwatch()..start();
    if (await _tryReuseConnectedHub(
      userId: userId,
      otherUserId: _activeOtherUserId,
    )) {
      _log(
        'connect #$attempt SUCCESS (reused) total ${totalSw.elapsedMilliseconds}ms',
      );
      return true;
    }

    if (hasActiveHubs) {
      await _stopAllTrackedHubs();
      _log('connect #$attempt pre-stop ${stopSw.elapsedMilliseconds}ms');
    }
    if (!_isConnectCurrent(connectEpoch) || !_isCurrentOp(opGen)) {
      return false;
    }
    _intentionalDisconnect = false;

    for (var startTry = 1; startTry <= _maxStartAttempts; startTry++) {
      HubConnection? startingHub;

      try {
        if (!_isConnectCurrent(connectEpoch) || !_isCurrentOp(opGen)) {
          _log('connect #$attempt cancelled before try $startTry');
          return false;
        }

        if (startTry > 1) {
          _log('connect #$attempt start retry $startTry/$_maxStartAttempts');
          await _stopAllTrackedHubs();
          if (!_isConnectCurrent(connectEpoch) || !_isCurrentOp(opGen)) {
            return false;
          }
          _intentionalDisconnect = false;
        }

        final buildSw = Stopwatch()..start();
        final connection = HubConnectionBuilder()
            .withUrl(
              '$baseUrl/chathub',
              options: _hubConnectionOptions(),
            )
            .withAutomaticReconnect()
            .build();
        startingHub = connection;
        _setPendingHub(connection);
        _log(
          'connect #$attempt hub built in ${buildSw.elapsedMilliseconds}ms',
        );

        void onIncoming(List<Object?>? arguments) {
          final msg = _parseIncoming(arguments);
          if (msg != null) {
            _emitIncomingMessage(msg);
          }
        }

        connection.on('receiveMessage', onIncoming);
        connection.on('ReceiveMessage', onIncoming);
        connection.on('OnReceiveMessage', onIncoming);

        connection.onclose(({Exception? error}) {
          _log(
            'onclose intentional=$_intentionalDisconnect error=$error',
          );
          if (!_intentionalDisconnect) {
            _emitConnection(false);
          }
        });

        connection.onreconnected(({String? connectionId}) async {
          _log('onreconnected connectionId=$connectionId');
          try {
            await connection.invoke('Connect', args: [userId]);
            await _invokeSetActiveChat(
              connection,
              userId,
              _activeOtherUserId,
            );
          } catch (e) {
            _log('onreconnected hub setup failed: $e');
          }
        });

        if (!_isConnectCurrent(connectEpoch) || !_isCurrentOp(opGen)) {
          _log('connect #$attempt cancelled before start try $startTry');
          await _tearDownHub(target: connection);
          return false;
        }

        final startSw = Stopwatch()..start();
        await _startHub(connection);
        _log(
          'connect #$attempt hub.start() try $startTry took ${startSw.elapsedMilliseconds}ms',
        );

        if (!_isConnectCurrent(connectEpoch) ||
            !_isCurrentOp(opGen) ||
            !identical(_pendingHub, connection)) {
          _log('connect #$attempt cancelled after start try $startTry');
          await _tearDownHub(target: connection);
          return false;
        }

        final invokeSw = Stopwatch()..start();
        await connection.invoke('Connect', args: [userId]);
        _log(
          'connect #$attempt Connect invoke took ${invokeSw.elapsedMilliseconds}ms',
        );

        await _invokeSetActiveChat(connection, userId, _activeOtherUserId);

        if (!_isConnectCurrent(connectEpoch) ||
            !_isCurrentOp(opGen) ||
            !identical(_pendingHub, connection)) {
          _log('connect #$attempt cancelled after invoke try $startTry');
          await _tearDownHub(target: connection);
          return false;
        }

        _promotePendingToActive(connection);

        _log(
          'connect #$attempt SUCCESS total ${totalSw.elapsedMilliseconds}ms '
          '(start ${startSw.elapsedMilliseconds}ms, invoke ${invokeSw.elapsedMilliseconds}ms, '
          'pre-stop ${stopSw.elapsedMilliseconds}ms)',
        );
        _emitConnection(true);
        return true;
      } catch (e, st) {
        _log(
          'connect #$attempt try $startTry FAILED after ${totalSw.elapsedMilliseconds}ms: $e',
        );
        if (kDebugMode) {
          debugPrint('$st');
        }
        await _tearDownHub(target: startingHub);
        await _settleAfterStop(milliseconds: 80 * startTry);

        if (!_isConnectCurrent(connectEpoch) || !_isCurrentOp(opGen)) {
          return false;
        }

        final canRetry =
            startTry < _maxStartAttempts && _isRetryableStartError(e);
        if (!canRetry) {
          _emitConnection(false);
          return false;
        }
      }
    }

    _emitConnection(false);
    return false;
  }

  Future<void> _invokeSetActiveChat(
    HubConnection connection,
    String currentUserId,
    String otherUserId,
  ) async {
    final otherId = otherUserId.trim();
    if (otherId.isEmpty) return;
    await connection.invoke(
      'SetActiveChat',
      args: [currentUserId.toString(), otherId],
    );
    _log('SetActiveChat: $currentUserId -> $otherId');
  }

  /// Stops hubs before a new connect (no connect-cancel token bump).
  Future<void> prepareForConnect() {
    return _enqueue(_stopAllTrackedHubs);
  }

  /// Marks this conversation active for server read/unread updates.
  Future<void> setActiveChat(String currentUserId, String otherUserId) {
    final active = hub;
    if (active == null || active.state != HubConnectionState.Connected) {
      return Future.value();
    }
    return _invokeSetActiveChat(active, currentUserId, otherUserId);
  }

  /// Clears active chat when leaving (server uses `0` as none).
  Future<void> clearActiveChat() {
    if (myUserId.trim().isEmpty) return Future.value();
    final active = hub;
    if (active == null || active.state != HubConnectionState.Connected) {
      return Future.value();
    }
    return _invokeSetActiveChat(active, myUserId, '0');
  }

  /// App background / leave chat — stop WebSocket without closing stream controllers.
  Future<void> pauseConnection() {
    _operationGen++;
    _intentionalDisconnect = true;
    final snapshot = _snapshotHubsForStop();
    return _enqueue(() async {
      final active = hub;
      if (active != null &&
          active.state == HubConnectionState.Connected &&
          myUserId.isNotEmpty) {
        try {
          await _invokeSetActiveChat(active, myUserId, '0');
        } catch (e) {
          _log('SetActiveChat clear on pause failed: $e');
        }
      }
      await _stopHubSnapshot(snapshot);
      _emitConnection(false);
    });
  }

  Future<void> sendConnectMessage(AdminConnectSendMessage payload) async {
    if (hub?.state != HubConnectionState.Connected) {
      throw StateError('Not connected to Connect hub');
    }
    await hub!.invoke('SendMessage', args: payload.toHubArgs());
  }

  Future<void> sendAgroAdminMessage({
    required String fromUserId,
    required String toUserId,
    required String apiCode,
    required String type1,
    required String type2,
    required AdminMessageInfo messageInfo,
  }) async {
    if (hub?.state != HubConnectionState.Connected) {
      throw StateError('Not connected to Connect hub');
    }
    await hub!.invoke(
      'SendMessage',
      args: [
        fromUserId,
        toUserId,
        apiCode,
        type1,
        type2,
        messageInfo.toJson(),
      ],
    );
  }

  Future<void> sendMessage(String toUser, ChatMessage chatMessage) async {
    if (hub?.state != HubConnectionState.Connected) return;
    await hub!
        .invoke('SendMessage', args: [myUserId, toUser, chatMessage.toJson()]);
  }

  Future<void> sendImage({
    required String toUser,
    required File file,
    String mimeType = 'image/jpeg',
    String? fileName,
  }) async {
    if (hub?.state != HubConnectionState.Connected) return;

    final bytes = await file.readAsBytes();
    final payload = ChatMessage(
      user: myUserId,
      message: fileName ?? file.path.split('/').last,
      file: base64Encode(bytes),
      fileType: mimeType,
      type: senderRole,
    );

    await hub!.invoke('SendFile', args: [payload.toJson(), toUser]);
  }

  Future<void> sendPdf({
    required String toUser,
    required File file,
    String? fileName,
  }) async {
    if (hub?.state != HubConnectionState.Connected) return;

    final bytes = await file.readAsBytes();
    final payload = ChatMessage(
      user: myUserId,
      message: fileName ?? file.path.split('/').last,
      file: base64Encode(bytes),
      fileType: 'application/pdf',
      type: senderRole,
    );

    await hub!.invoke('SendFile', args: [payload.toJson(), toUser]);
  }

  Future<void> sendVoice({
    required String toUser,
    required File file,
    required Duration duration,
  }) async {
    if (hub?.state != HubConnectionState.Connected) return;

    final bytes = await file.readAsBytes();
    final payload = ChatMessage(
      user: myUserId,
      message: 'Voice message (${_formatDuration(duration)})',
      file: base64Encode(bytes),
      fileType: 'audio/m4a',
      type: senderRole,
      duration: duration,
    );

    await hub!.invoke('SendFile', args: [payload.toJson(), toUser]);
  }

  Future<void> sendTyping(String toUser) async {
    if (hub?.state == HubConnectionState.Connected) {
      await hub!.invoke('Typing', args: [myUserId, toUser]);
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  ChatMessage? _parseIncoming(List<Object?>? arguments) {
    if (arguments == null || arguments.isEmpty) return null;

    try {
      final map = _flattenMessageInfo(_normalizeIncomingPayload(arguments));
      if (map == null || map.isEmpty) return null;

      final text = _extractMessageText(map);
      final file = _extractFile(map);
      final fileType = _extractFileType(map);

      if (text.isEmpty && (file == null || file.isEmpty)) return null;

      final fromUser = _extractFromUser(map);
      final isMe = _resolveIsMe(map, fromUser);
      final timestamp = _extractTimestamp(map);

      return ChatMessage(
        user: fromUser,
        message: text,
        file: file,
        fileType: fileType,
        isMe: isMe,
        timestamp: timestamp,
      );
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? _flattenMessageInfo(Map<String, dynamic>? map) {
    if (map == null) return null;
    final nested = map['MessageInfo'] ?? map['messageInfo'];
    if (nested is Map) {
      return {...map, ...Map<String, dynamic>.from(nested)};
    }
    return map;
  }

  Map<String, dynamic>? _normalizeIncomingPayload(List<Object?> arguments) {
    if (arguments.length == 1) {
      return _mapFromDynamic(arguments[0]);
    }

    if (arguments.length >= 6) {
      final info = _mapFromDynamic(arguments[5]) ?? {};
      final type2 = arguments[4]?.toString();
      return _flattenMessageInfo({
        'fromUserId': arguments[0]?.toString(),
        'toUserId': arguments[1]?.toString(),
        'msgFrom': info['msgFrom'] ?? info['MsgFrom'] ?? type2,
        ...info,
      });
    }

    if (arguments.length == 3) {
      return _parseThreeArgPayload(arguments);
    }

    if (arguments.length >= 4) {
      final info = _mapFromDynamic(arguments[3]) ??
          _mapFromDynamic(arguments.last) ??
          {};
      return _flattenMessageInfo({
        'fromUserId': arguments[0]?.toString(),
        'toUserId': arguments[1]?.toString(),
        'msgFrom': info['msgFrom'] ?? info['MsgFrom'],
        ...info,
      });
    }

    if (arguments.length == 2) {
      final first = _mapFromDynamic(arguments[0]);
      final second = _mapFromDynamic(arguments[1]);
      if (first != null && second != null) {
        return {...first, ...second};
      }
      return first ?? second;
    }

    final merged = <String, dynamic>{};
    for (final arg in arguments) {
      final m = _mapFromDynamic(arg);
      if (m != null) merged.addAll(m);
    }
    return merged.isEmpty ? null : merged;
  }

  Map<String, dynamic>? _parseThreeArgPayload(List<Object?> arguments) {
    if (arguments[1] is Map) {
      final info = Map<String, dynamic>.from(arguments[1] as Map);
      final ts = arguments[2];
      return _flattenMessageInfo({
        'fromUserId': arguments[0]?.toString(),
        if (ts != null && _looksLikeIsoDate(ts.toString()))
          'insertedDate': ts.toString(),
        'msgFrom': info['msgFrom'] ?? info['MsgFrom'] ?? info['type'],
        ...info,
      });
    }

    final info = _mapFromDynamic(arguments[2]) ?? {};
    return _flattenMessageInfo({
      'fromUserId': arguments[0]?.toString(),
      'toUserId': arguments[1]?.toString(),
      'msgFrom': info['msgFrom'] ?? info['MsgFrom'],
      ...info,
    });
  }

  Map<String, dynamic>? _mapFromDynamic(Object? value) {
    if (value == null) return null;
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    if (value is List) {
      final merged = <String, dynamic>{};
      for (final item in value) {
        final m = _mapFromDynamic(item);
        if (m != null) merged.addAll(m);
      }
      return merged.isEmpty ? null : merged;
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        try {
          final decoded = jsonDecode(trimmed);
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded);
          }
        } catch (_) {}
      }
      if (!_looksLikeIsoDate(trimmed)) {
        return {'msgContent': trimmed};
      }
      return {'insertedDate': trimmed};
    }
    return null;
  }

  bool _looksLikeIsoDate(String value) {
    return RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(value);
  }

  String _extractMessageText(Map<String, dynamic> map) {
    const keys = [
      'msgContent',
      'MsgContent',
      'message',
      'Message',
      'msg_content',
      'text',
      'Text',
    ];
    for (final key in keys) {
      final value = map[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return '';
  }

  String _extractFromUser(Map<String, dynamic> map) {
    return map['msgFrom']?.toString() ??
        map['MsgFrom']?.toString() ??
        map['fromUserId']?.toString() ??
        map['FromUserId']?.toString() ??
        map['user']?.toString() ??
        '';
  }

  String? _extractFile(Map<String, dynamic> map) {
    final file = map['file']?.toString() ??
        map['File']?.toString() ??
        map['fileURL']?.toString() ??
        map['FileURL']?.toString();
    if (file == null || file.trim().isEmpty) return null;
    return file.trim();
  }

  String? _extractFileType(Map<String, dynamic> map) {
    final type =
        map['fileType']?.toString() ?? map['FileType']?.toString();
    return type != null && type.isNotEmpty ? type : null;
  }

  DateTime? _extractTimestamp(Map<String, dynamic> map) {
    final raw = map['insertedDate'] ??
        map['InsertedDate'] ??
        map['timestamp'] ??
        map['Timestamp'];
    if (raw == null) return null;
    return _parseServerDateTime(raw.toString());
  }

  /// Parses backend ISO strings (often UTC) for consistent local display.
  DateTime? _parseServerDateTime(String raw) {
    try {
      return DateTime.parse(raw).toLocal();
    } catch (_) {
      return null;
    }
  }

  bool _resolveIsMe(Map<String, dynamic> map, String fromUserId) {
    final msgFrom =
        (map['msgFrom'] ?? map['MsgFrom'] ?? map['type2'] ?? map['Type2'] ?? '')
            .toString()
            .toLowerCase();
    if (msgFrom.isNotEmpty) {
      if (_isVendorSide) {
        return msgFrom == 'vendor' || msgFrom.contains('vendor');
      }
      return msgFrom == 'admin' || msgFrom.contains('admin');
    }
    return fromUserId == myUserId;
  }

  Future<void> disconnect() {
    return stopAllConnections();
  }

  Future<void> dispose() {
    return _enqueue(_disposeInternal);
  }

  Future<void> _disposeInternal() async {
    _log('dispose');
    _operationGen++;
    _intentionalDisconnect = true;
    await _tearDownHub();
    await _settleAfterStop();
    if (!_messageController.isClosed) await _messageController.close();
    if (!_connectionController.isClosed) await _connectionController.close();
    if (!_typingController.isClosed) await _typingController.close();
  }
}
