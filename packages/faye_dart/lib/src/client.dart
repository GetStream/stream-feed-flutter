import 'dart:async';
import 'dart:convert';

import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/message.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../src/ws/web_socket_channel_stub.dart'
    if (dart.library.html) '../src/ws/web_socket_channel_html.dart'
    if (dart.library.io) '../src/ws/web_socket_channel_io.dart' as platform;

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

typedef VoidCallback = void Function();

const defaultConnectionTimeout = 60;
const defaultConnectionInterval = 0;

class AuthExtension {
  Map<String, String>? ext = {};
  Map<String, String>? getAuth() => ext; //TODO: throw maybe?
}

class FayeClient<T extends AuthExtension> {
  final String baseUrl;
  final Iterable<String>? protocols;
  final bool logsEnabled;
  final int healthCheckInterval;
  final int maxAttemptsToReconnect;
  final _channels = <String, Channel>{};
  final T? authExtension;
  late WebSocketChannel? _webSocketChannel;

  int _attemptsToReconnect = 0;
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

//
//     private lazy var handshakeTimer = RepeatingTimer(timeInterval: .seconds(30), queue: webSocket.callbackQueue) { [weak self] in
//         self?.ping()
//     }
  Timer? _healthCheckTimer;

//
//     /// Create a Faye client with a given `URLRequest`.
//     ///
//     /// - Parameters:
//     ///     - urlRequest: an `URLRequest` with `URL`, custom headers and a timeout parameter.
//     ///     - callbackQueue: a DispatchQueue for requests.
//     public init(urlRequest: URLRequest,
//                 callbackQueue: DispatchQueue = DispatchQueue(label: "io.getstream.Faye", qos: .userInitiated)) {
//         var request = urlRequest
//         request.setValue("faye", forHTTPHeaderField: "Sec-WebSocket-Protocol")
//         webSocket = WebSocket(request: request)
//         webSocket.callbackQueue = callbackQueue
//         webSocket.delegate = self
//     }
  StreamSubscription? _websocketSubscription;

  DateTime? _lastEventAt;
  Completer<void>? _connectionCompleter;
  Completer<void>? _disconnectionCompleter;

  FayeClient(
    this.baseUrl, {
    this.authExtension,
    this.protocols,
    this.logsEnabled = false,
    this.healthCheckInterval = 10,
    this.maxAttemptsToReconnect = 5,
  });

  //    if (_writeClosed) return;
  //     _pingTimer?.cancel();
  //     _pingInterval = interval;
  //
  //     if (interval == null) return;
  //
  //     _pingTimer = new Timer(interval, () {
  //       if (_writeClosed) return;
  //       _consumer.add(new _WebSocketPing());
  //       _pingTimer = new Timer(interval, () {
  //         _closeTimer?.cancel();
  //         // No pong received.
  //         _close(WebSocketStatus.goingAway);
  //         _closeCode = _outCloseCode;
  //         _closeReason = _outCloseReason;
  //         _controller.close();
  //       });
  //     });

  //public func connect() {
//         guard !isConnected else {
//             return
//         }
//
//         log("Connecting WS...")
//         self.webSocket.connect()
//     }

  void _handshake() {
    if (_advice.reconnect == Advice.none) return;
    if (state != FayeClientState.unconnected) return;

    state = FayeClientState.connecting;

    // log initiating handshake

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

    // TODO : Add logger
    _connectionCompleter = Completer();
    _webSocketChannel = await platform.connectWebSocket(
      baseUrl,
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
      // logError
    }
    final interval = _advice.interval ~/ 1000;
    _cycleConnection(interval: Duration(seconds: interval));
  }

  void _handleSubscribeChannelResponse(Message message) {
    print("received subscription message : $message");
    final subscription = message.subscription;
    final channel = _channels[subscription];
    if (message.successful == true) {
      final channels = [message.subscription];
      // this.info('Subscription acknowledged for ? to ?', this._dispatcher.clientId, channels);
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
      final channels = [message.subscription];
      // this.info('Unsubscription acknowledged for ? to ?', this._dispatcher.clientId, channels);
    } else {
      // logError
    }
  }

  void _handleDisconnectChannelResponse(Message message) {
    if (message.successful == true) {
      _clientId = null;
      _webSocketChannel?.sink.close(status.goingAway);
      _websocketSubscription?.cancel();
      _disconnectionCompleter?.complete();
    } else {
      // logError
      final error = message.error ?? 'Error disconnecting client';
      _disconnectionCompleter?.completeError(error);
    }
  }

  void _onDataReceived(dynamic data) {
    final json = jsonDecode(data);
    final messages = (json as List).map((it) => Message.fromJson(it));
    //TODO: refactor so that we return a stream<Message> in subscribe()
    print("messages : $messages");
    for (final message in messages) {
      if (message.advice != null) _handleAdvice(message.advice!);
      _deliverMessage(message);
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
        // Faye received a message with no subscription for channel
        // ${message.subscription}
      }
    }
  }

  void _startHealthCheck() {
    _healthCheckTimer?.cancel();

    final duration = Duration(seconds: healthCheckInterval);
    _healthCheckTimer = Timer(duration, () {
      ping();
      _healthCheckTimer = Timer(duration, () {
        _healthCheckTimer?.cancel();
        // No pong received.
        disconnect();
      });
    });
  }

  //             isWebSocketConnected = false
  //             log()
  //             handshakeTimer.suspend()
  //             clientId = nil
  //
  //             log("❌ WS Disconnect: \(reason), \(code)")
  //
  //             applyAdvice()
  void _onConnectionError(Object error, [StackTrace? stacktrace]) {
    // _isWebSocketConnected = false;
    // // TODO : log
    // // TODO : Pause handshakeTimer
    // _clientId = null;
    // // TODO : Log disconnected;
    // _handleAdvice();
  }

  //             isWebSocketConnected = false
  //             log("❌ WS Disconnect with error: \(error)")
  //             //handleError(error)
  void _onConnectionClosed() {
    Future.delayed(const Duration(seconds: 6), () {
      print(_webSocketChannel?.closeCode);
    });
    // _isWebSocketConnected = false;
    // // TODO: LogConnectionClosed;
    // // Checking if we manually closed the connection
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
    // log("🏓 --->")
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
    if ((auth != null) & (authExtension != null)) {
      message.ext = authExtension!.getAuth();
    }
    print("sending message : $message");
    final data = jsonEncode(message);

    _webSocketChannel?.sink.add(data);
  }

  void _subscribeChannels() {
    for (final channel in _channels.keys) subscribe(channel, force: true);
  }

  Future<Subscription> subscribe(
    String channel, {
    ChannelCallback? callback,
    bool force = false,
  }) async {
    final subscription = Subscription(this, channel, callback: callback);
    final hasSubscribe = _channels.contains(channel);

    if (hasSubscribe && !force) {
      _channels.subscribe([channel], subscription);
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

  _deliverMessage(Message message) {
    // if (message.data == null) return;
    // this.info('Client ? calling listeners for ? with ?', this._dispatcher.clientId, message.channel, message.data);
    _channels.distributeMessage(message);
  }

  Future<void> disconnect() async {
    if (state != FayeClientState.connected) return;
    state = FayeClientState.disconnected;
    // this.info('Disconnecting ?', this._dispatcher.clientId);
    _disconnectionCompleter = Completer();
    _sendMessage(disconnect_channel);
    return _disconnectionCompleter!.future;
  }

  //
  //
  // // MARK: - Error
  //
  // extension Client {
  //     public enum Error: String, Swift.Error {
  //         case notConnected
  //         case clientIdIsEmpty
  //     }
  // }
  //

  void _log([
    String title = '',
    Object? item1,
    Object? item2,
    Object? item3,
    String Function()? function,
  ]) {
    if (logsEnabled) {
      print('''
          🕸 $title,
          Date : ${DateTime.now()},
          ${item1 ?? ''},
          ${item2 ?? ''},
          ${item3 ?? ''},
          ''');
    }
  }
}

class _WebSocketPing {
  final List<int>? payload;

  const _WebSocketPing([this.payload = null]);
}
