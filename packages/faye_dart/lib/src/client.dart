import 'dart:async';
import 'dart:convert';

import 'package:faye_dart/faye_dart.dart';
import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:logging/logging.dart';
import 'extensible.dart';
import 'dart:math' as math;

import 'package:faye_dart/src/subscription.dart';

enum FayeClientState {
  unconnected,
  connecting,
  connected,
  disconnected,
}

/// Handler function used for logging records. Function requires a single
/// [LogRecord] as the only parameter.
typedef LogHandlerFunction = void Function(LogRecord record);

final _levelEmojiMapper = {
  Level.INFO: 'ℹ️',
  Level.WARNING: '⚠️',
  Level.SEVERE: '🚨',
};

typedef VoidCallback<T> = T Function();
typedef MessageCallback = void Function(Message message);

const defaultConnectionTimeout = 60;
const defaultConnectionInterval = 0;
const bayeuxVersion = '1.0';

class FayeClient with Extensible {
  FayeClient(
    String baseUrl, {
    Iterable<String>? protocols,
    this.retry = 5,
    Level logLevel = Level.WARNING,
    LogHandlerFunction? logHandlerFunction,
  }) : _logger = Logger.detached('🕒')..level = logLevel {
    _logger.onRecord.listen(logHandlerFunction ?? _defaultLogHandler);
    _webSocketChannel = WebSocketChannel.connect(
      Uri.parse(baseUrl),
      protocols: protocols,
    );
    _subscribeToWebsocket();
  }

  String? _clientId;

  final int retry;
  final _channels = <String, Channel>{};
  late final WebSocketChannel _webSocketChannel;

  var _advice = Advice(
    reconnect: Advice.retry,
    interval: 1000 * defaultConnectionInterval,
    timeout: 1000 * defaultConnectionTimeout,
  );

  var _fayeClientState = FayeClientState.unconnected;

  final _stateController = StreamController<FayeClientState>.broadcast();

  set _state(FayeClientState state) {
    _fayeClientState = state;
    _stateController.add(state);
  }

  /// The current state of the client
  FayeClientState get state => _fayeClientState;

  /// The current state of the client in the form of stream
  Stream<FayeClientState> get stateStream => _stateController.stream;

  StreamSubscription? _websocketSubscription;

  bool _connectRequest = false;

  final _responseCallbacks = <String, MessageCallback>{};

  final Logger _logger;

  void _defaultLogHandler(LogRecord record) {
    print(
      '(${record.time}) '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '${record.loggerName} ${record.message}',
    );
    if (record.stackTrace != null) print(record.stackTrace);
  }

  void _subscribeToWebsocket() {
    if (_websocketSubscription != null) {
      _unsubscribeFromWebsocket();
    }
    _websocketSubscription = _webSocketChannel.stream.listen(
      _onDataReceived,
      onError: _onConnectionError,
      onDone: _onConnectionClosed,
    );
  }

  void _unsubscribeFromWebsocket() {
    if (_websocketSubscription != null) {
      _websocketSubscription!.cancel();
      _websocketSubscription = null;
    }
  }

  void _onDataReceived(dynamic data) {
    final json = jsonDecode(data) as List;
    Iterable<Message>? messages;
    try {
      messages = json.map((it) => Message.fromJson(it));
    } catch (_) {}

    if (messages == null) return;

    for (final message in messages) {
      _receiveMessage(message);
    }
  }

  void _onConnectionError(Object error, [StackTrace? stacktrace]) {
    // _isWebSocketConnected = false;
    _logger.severe("onConnectionError $error");
    // TODO : Pause handshakeTimer
    // _clientId = null;
    _logger.info("disconnected");
    // _handleAdvice();
  }

  void _onConnectionClosed() {
    _logger.info("Log Connection Closed");
    // Checking if we manually closed the connection
    if (_webSocketChannel.closeCode == status.goingAway) {
      return;
    }
    // _handleAdvice();
  }

  void handshake({VoidCallback? callback}) {
    if (_advice.reconnect == Advice.none) return;
    if (state != FayeClientState.unconnected) return;

    _state = FayeClientState.connecting;

    _logger.info("initiating handshake");

    _sendMessage(
      Message(
        Channel.handshake,
        version: bayeuxVersion,
        supportedConnectionTypes: ['websocket'],
      ),
      onResponse: (response) {
        if (response.successful == true) {
          _state = FayeClientState.connected;
          _clientId = response.clientId;

          _logger.info('Handshake successful: $_clientId');
          _subscribeChannels(_channels.keys, force: true);
          callback?.call();
        } else {
          _logger.info('Handshake unsuccessful');
          Future.delayed(
            Duration(seconds: retry),
            () => handshake(callback: callback),
          );
          _state = FayeClientState.unconnected;
        }
      },
    );
  }

  void connect({VoidCallback? callback}) {
    if (_advice.reconnect == Advice.none) return;
    if (state == FayeClientState.disconnected) return;

    if (state == FayeClientState.unconnected) {
      return handshake(callback: () => connect(callback: callback));
    }

    callback?.call();
    if (state != FayeClientState.connected) return;

    if (_connectRequest) return;
    _connectRequest = true;

    _logger.info('Initiating connection for $_clientId');

    _sendMessage(
      Message(
        Channel.connect,
        clientId: _clientId,
        connectionType: 'websocket',
      ),
      onResponse: (_) => _cycleConnection(),
    );
  }

  Future<void> disconnect() async {
    if (state != FayeClientState.connected) return;
    _state = FayeClientState.disconnected;

    _logger.info('Disconnecting $_clientId');
    final _disconnectionCompleter = Completer<void>();

    _sendMessage(
      Message(
        Channel.disconnect,
        clientId: _clientId,
      ),
      onResponse: (response) {
        if (response.successful == true) {
          _webSocketChannel.sink.close(status.goingAway);
          _websocketSubscription?.cancel();
          _disconnectionCompleter.complete();
        } else {
          final error = FayeClientError.parse(response.error);
          _disconnectionCompleter.completeError(error);
        }
      },
    );

    _logger.info('Clearing channel listeners for $_clientId');
    _channels.clear();

    return _disconnectionCompleter.future;
  }

  void _subscribeChannels(Iterable<String> channels, {bool force = false}) {
    for (final channel in channels) subscribe(channel, force: force);
  }

  Future<Subscription> subscribe(
    String channel, {
    Callback? callback,
    bool force = false,
  }) async {
    final _subscriptionCompleter = Completer<Subscription>();

    final subscription = Subscription(this, channel, callback: callback);
    final hasSubscribe = _channels.contains(channel);

    if (hasSubscribe && !force) {
      _channels.subscribe(channel, subscription);
      _subscriptionCompleter.complete(subscription);
    } else {
      connect(callback: () {
        _logger.info('Client $_clientId attempting to subscribe to $channel');
        if (!force) _channels.subscribe(channel, subscription);
        _sendMessage(
          Message(
            Channel.subscribe,
            clientId: _clientId,
            subscription: channel,
          ),
          onResponse: (response) {
            if (response.successful == false) {
              _channels.unsubscribe(channel, subscription);
              final error = FayeClientError.parse(response.error);
              _subscriptionCompleter.completeError(error);
              return;
            }

            final _channel = response.subscription;
            _logger.info(
              'Subscription acknowledged for $_channel to $_clientId',
            );
            _subscriptionCompleter.complete(subscription);
          },
        );
      });
    }
    return _subscriptionCompleter.future;
  }

  void unsubscribe(String channel, Subscription subscription) {
    final dead = _channels.unsubscribe(channel, subscription);
    if (!dead) return;

    connect(callback: () {
      _logger.info('Client $_clientId attempting to unsubscribe from $channel');
      _sendMessage(
        Message(
          Channel.unsubscribe,
          clientId: _clientId,
          subscription: channel,
        ),
        onResponse: (response) {
          if (response.successful == false) return;

          final _channel = response.subscription;
          _logger.info(
            'Unsubscription acknowledged for $_clientId from $_channel',
          );
        },
      );
    });
  }

  Future<void> publish(
    String channel, {
    required Map<String, Object?> data,
  }) {
    final _publishCompleter = Completer<void>();

    connect(callback: () {
      _logger.info(
        'Client $_clientId queueing published message to $channel: $data',
      );
      _sendMessage(
        Message(
          channel,
          data: data,
          clientId: _clientId,
        ),
        onResponse: (response) {
          if (response.successful == true) {
            _publishCompleter.complete();
          } else {
            final error = FayeClientError.parse(response.error);
            _publishCompleter.completeError(error);
          }
        },
      );
    });
    return _publishCompleter.future;
  }

  int _messageId = 0;

  String _generateMessageId() {
    _messageId += 1;
    if (_messageId >= math.pow(2, 32)) _messageId = 0;
    return _messageId.toRadixString(36);
  }

  void _sendMessage(Message message, {MessageCallback? onResponse}) {
    final id = _generateMessageId();
    message.id = id;
    pipeThroughExtensions('outgoing', message, (message) {
      _logger.info("sending message : $message");
      if (onResponse != null) _responseCallbacks[id] = onResponse;
      final data = jsonEncode(message);
      _webSocketChannel.sink.add(data);
    });
  }

  void _receiveMessage(Message message) {
    final id = message.id;
    MessageCallback? callback;
    if (message.successful != null) {
      callback = _responseCallbacks.remove(id);
    }
    pipeThroughExtensions('incoming', message, (message) {
      _logger.info("received message : $message");
      if (message.advice != null) _handleAdvice(message.advice!);
      _deliverMessage(message);
      callback?.call(message);
    });
  }

  void _handleAdvice(Advice advice) {
    _advice = advice;
    if (_advice.reconnect == Advice.handshake &&
        state != FayeClientState.disconnected) {
      _state = FayeClientState.unconnected;
      _clientId = null;
      _cycleConnection();
    }
  }

  void _deliverMessage(Message message) {
    if (message.data == null) return;
    _logger.info(
      'Client $_clientId calling listeners for ${message.channel} '
      'with ${message.data}',
    );
    _channels.distributeMessage(message);
  }

  void _cycleConnection() {
    if (_connectRequest) {
      _connectRequest = false;
      _logger.info('Closed connection for $_clientId');
    }
    Future.delayed(Duration(milliseconds: _advice.interval), () => connect());
  }
}
