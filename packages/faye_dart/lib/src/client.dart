import 'dart:async';
import 'dart:convert';

import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/message.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:logging/logging.dart';
import 'extensible.dart';

part 'subscription.dart';

/// Typedef used for connecting to a websocket. Method returns a
/// [WebSocketChannel] and accepts a connection [url] and an optional
/// [Iterable] of `protocols`.
typedef ConnectWebSocket = WebSocketChannel? Function(
  String url, {
  Iterable<String>? protocols,
  Duration? connectionTimeout,
});

enum FayeClientState {
  unconnected,
  connecting,
  connected,
  disconnected,
}

typedef LogHandlerFunction = void Function(LogRecord record);
final _levelEmojiMapper = {
  Level.INFO: 'ℹ️',
  Level.WARNING: '⚠️',
  Level.SEVERE: '🚨',
};

typedef VoidCallback = void Function();

const defaultConnectionTimeout = 60;
const defaultConnectionInterval = 0;

class FayeClient with Extensible {
  final String baseUrl;
  final Iterable<String>? protocols;
  final bool logsEnabled;
  final int healthCheckInterval;
  final int maxAttemptsToReconnect;
  final _channels = <String, Channel>{};
  late WebSocketChannel? _webSocketChannel;

  String? _clientId;

  late Advice _advice = Advice(
    reconnect: Advice.retry,
    interval: 1000 * defaultConnectionInterval,
    timeout: 1000 * defaultConnectionTimeout,
  );

  final _stateController = BehaviorSubject.seeded(FayeClientState.unconnected);

  set state(FayeClientState state) => _stateController.add(state);

  /// The current state of the client
  FayeClientState get state => _stateController.value!;

  /// The current state of the client in the form of stream
  Stream<FayeClientState> get stateStream => _stateController.stream;

  StreamSubscription? _websocketSubscription;

  Completer<void>? _connectionCompleter;
  Completer<void>? _disconnectionCompleter;

  FayeClient(
    this.baseUrl, {
    this.protocols,
    this.logsEnabled = false,
    this.healthCheckInterval = 10,
    this.maxAttemptsToReconnect = 5,
    Level logLevel = Level.WARNING,
    LogHandlerFunction? logHandlerFunction,
  }) : _logger = Logger.detached('🕒')..level = logLevel {
    _logger.onRecord.listen(logHandlerFunction ?? _defaultLogHandler);
    _logger.info('instantiating a faye client');
  }
  final Logger _logger;

  void _defaultLogHandler(LogRecord record) {
    print(
      '(${record.time}) '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '${record.loggerName} ${record.message}',
    );
    if (record.stackTrace != null) print(record.stackTrace);
  }

  void _handshake() {
    if (_advice.reconnect == Advice.none) return;
    if (state != FayeClientState.unconnected) return;

    state = FayeClientState.connecting;

    _logger.info("initiating handshake");

    _sendMessage(handshake_channel);
  }

  void _connectFaye() {
    if (_advice.reconnect == Advice.none) return;
    if (state == FayeClientState.disconnected) return;

    if (state == FayeClientState.unconnected) {
      _handshake();
      return;
    }
    _sendMessage(connect_channel);
  }

  Future<void> connect() async {
    if (state == FayeClientState.connected) return;

    _connectionCompleter = Completer();
    _webSocketChannel = WebSocketChannel.connect(
      Uri.parse(baseUrl),
      protocols: protocols,
    );
    _subscribeToWebsocket();
    _connectFaye();
    return _connectionCompleter!.future;
  }

  void _subscribeToWebsocket() {
    if (_websocketSubscription != null) {
      _unsubscribeFromWebsocket();
    }
    _websocketSubscription = _webSocketChannel?.stream.listen(
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

  void _handleHandshakeChannelResponse(Message message) {
    if (message.successful == true) {
      state = FayeClientState.connected;
      _clientId = message.clientId;
      _subscribeChannels();
      _sendMessage(connect_channel);
      _connectionCompleter?.complete();
    } else {
      // logError
      state = FayeClientState.unconnected;
      Future.delayed(const Duration(seconds: 2), () => _handshake());
    }
  }

  void _handleConnectChannelResponse(Message message) {
    if (message.successful == true) {
      state = FayeClientState.connected;
      if (message.advice != null) {
        _advice = message.advice!;
      }
    } else {
      _logger.severe("error in handling Connect Channel Response");
    }
    final interval = _advice.interval ~/ 1000;
    _cycleConnection(interval: Duration(seconds: interval));
  }

  void _handleSubscribeChannelResponse(Message message) {
    print("received subscription message : $message");
    final subscription = message.subscription;
    final channel = _channels[subscription];
    if (message.successful == true) {
      final channels = [message.subscription]; //TODO: not used?
      _logger.info("Subscription acknowledged for ${_clientId} to ${channels}");
      channel!.subscription?._complete();
    } else {
      // logError
      final error = message.error ?? 'Error subscribing channel';
      channel!.subscription?._completeError(error);
      _channels.unsubscribe(subscription!, channel.subscription!);
    }
  }

  void _handleUnsubscribeChannelResponse(Message message) {
    if (message.successful == true) {
      final channels = [message.subscription]; //TODO: unused?
      _logger
          .info("Unsubscription acknowledged for ${_clientId} to ${channels}");
    } else {
      _logger.severe(
          "received message not successful while handling Unsubscribe ChannelResponse: ${message.toString()}");
    }
  }

  void _handleDisconnectChannelResponse(Message message) {
    if (message.successful == true) {
      _clientId = null;
      _webSocketChannel?.sink.close(status.goingAway);
      _websocketSubscription?.cancel();
      _disconnectionCompleter?.complete();
    } else {
      final error = message.error ?? 'Error disconnecting client';
      _logger.severe(error);
      _disconnectionCompleter?.completeError(error);
    }
  }

  void _onDataReceived(dynamic data) {
    final json = jsonDecode(data);
    final messages = (json as List).map((it) => Message.fromJson(it));
    for (final message in messages) {
      if (message.advice != null) _handleAdvice(message.advice!);
      final channel = message.channel;
      if (channel == handshake_channel) {
        _handleHandshakeChannelResponse(message);
      } else if (channel == connect_channel) {
        _handleConnectChannelResponse(message);
      } else if (channel == subscribe_channel) {
        _handleSubscribeChannelResponse(message);
      } else if (channel == unsubscribe_channel) {
        _handleUnsubscribeChannelResponse(message);
      } else if (channel == disconnect_channel) {
        _handleDisconnectChannelResponse(message);
      } else if (_channels.contains(channel)) {
        if (message.advice != null) _handleAdvice(message.advice!);
        _channels.distributeMessage(message);
      } else {
        _logger.severe(
            "Faye received this message with no subscription for channel ${message.subscription}: ${message}");
      }
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
    Future.delayed(const Duration(seconds: 6), () {
      print(_webSocketChannel?.closeCode);
    });
    _logger.info("Log Connection Closed");
    // Checking if we manually closed the connection
    if (_webSocketChannel?.closeCode == status.goingAway) {
      return;
    }
    // _handleAdvice();
  }

  void _cycleConnection({Duration interval = const Duration(seconds: 2)}) {
    Future.delayed(interval, () => _connectFaye());
  }

  void ping() {
    // TODO : Log
    _logger.info("🏓 --->");
    _webSocketChannel?.sink.add(const _WebSocketPing());
  }

  //private func webSocketWrite(_ bayeuxChannel: BayeuxChannel,
  //                                 _ channel: Channel? = nil,
  //                                 completion: ClientWriteDataCompletion? = nil) throws {
  //         guard isWebSocketConnected else {
  //             throw Error.notConnected
  //         }
  //
  //         guard clientId != nil || bayeuxChannel == BayeuxChannel.handshake else {
  //             throw Error.clientIdIsEmpty
  //         }
  //
  //         let message = Message(bayeuxChannel, channel, clientId: self.clientId)
  //         let data = try JSONEncoder().encode([message])
  //         webSocket.write(data: data, completion: completion)
  //         log("--->", message.channel, message.clientId ?? "", message.ext ?? [:])
  //     }

  void _sendMessage(String bayeuxChannel, {String? channel, bool? auth}) {
    final message = Message(
      bayeuxChannel,
      channel: _channels[channel],
      clientId: _clientId,
    );
    pipeThroughExtensions('outgoing', message, (message) {
      _logger.info("sending message : $message");
      final data = jsonEncode(message);
      _webSocketChannel?.sink.add(data);
    });
  }

  void _subscribeChannels() {
    for (final channel in _channels.keys) subscribe(channel, force: true);
  }

  Future<Subscription> subscribe(
    String channel, {
    Callback? callback,
    bool force = false,
  }) async {
    final subscription = Subscription(this, channel, callback: callback);
    final hasSubscribe = _channels.contains(channel);

    if (hasSubscribe && !force) {
      _channels.subscribe([channel], subscription); //TODO channel expand
      subscription._complete();
    } else {
      if (!force) _channels.subscribe([channel], subscription);
      _sendMessage(subscribe_channel, channel: channel, auth: true);
    }
    return subscription._future;
  }

  void unsubscribe(String channel, Subscription subscription) {
    final dead = _channels.unsubscribe(channel, subscription);
    if (!dead) return;

    if (state != FayeClientState.connected) return;
    _sendMessage(unsubscribe_channel, channel: channel);
  }

  void _handleAdvice(Advice advice) {
    _advice = advice;
    // this._dispatcher.timeout = this._advice.timeout / 1000;
    if (_advice.reconnect == Advice.handshake &&
        state != FayeClientState.disconnected) {
      state = FayeClientState.unconnected;
      _clientId = null;
      _cycleConnection();
    }
  }

  Future<void> disconnect() async {
    if (state != FayeClientState.connected) return;
    state = FayeClientState.disconnected;
    _logger.info('Disconnecting $_clientId');
    _disconnectionCompleter = Completer();
    _sendMessage(disconnect_channel);
    return _disconnectionCompleter!.future;
  }
}

class _WebSocketPing {
  final List<int>? payload;

  const _WebSocketPing([this.payload = null]);
}
